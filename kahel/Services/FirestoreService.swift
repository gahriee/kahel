import Foundation
import FirebaseFirestore
import Combine

struct ExpensePage {
    let items: [Expense]
    let cursor: DocumentSnapshot?
    let hasMore: Bool
}

class FirestoreService {
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private init() {
        // Init logic if needed
    }
    
    // MARK: - Date Helpers
    
    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: Date())
    }
    
    var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    // MARK: - Watchers (Combine Publishers)
    
    func watchUser(uid: String) -> AnyPublisher<UserProfile?, Never> {
        let subject = CurrentValueSubject<UserProfile?, Never>(nil)
        db.collection("users").document(uid).addSnapshotListener { snapshot, _ in
            guard let dict = snapshot?.data() else {
                subject.send(nil)
                return
            }
            subject.send(UserProfile(from: dict))
        }
        return subject.eraseToAnyPublisher()
    }
    
    func watchExpenses(uid: String) -> AnyPublisher<[Expense], Never> {
        let subject = CurrentValueSubject<[Expense], Never>([])
        db.collection("users").document(uid).collection("expenses")
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .addSnapshotListener { snapshot, _ in
                guard let docs = snapshot?.documents else {
                    subject.send([])
                    return
                }
                let expenses = docs.map { Expense(from: $0.data(), id: $0.documentID) }
                subject.send(expenses)
            }
        return subject.eraseToAnyPublisher()
    }
    
    func watchBudget(uid: String) -> AnyPublisher<Budget?, Never> {
        let subject = CurrentValueSubject<Budget?, Never>(nil)
        // In the original, there was a specific document 'active' or querying by month.
        // Assuming we store current budget at `users/{uid}/budgets/active` or `users/{uid}/budget/current`
        db.collection("users").document(uid).collection("budgets").document(currentMonth).addSnapshotListener { snapshot, _ in
            guard let dict = snapshot?.data() else {
                subject.send(nil)
                return
            }
            subject.send(Budget(from: dict))
        }
        return subject.eraseToAnyPublisher()
    }
    
    func watchTodayQuests(uid: String) -> AnyPublisher<DailyQuest?, Never> {
        let subject = CurrentValueSubject<DailyQuest?, Never>(nil)
        db.collection("users").document(uid).collection("quests").document(todayString).addSnapshotListener { snapshot, _ in
            guard let dict = snapshot?.data() else {
                subject.send(nil)
                return
            }
            subject.send(DailyQuest(from: dict))
        }
        return subject.eraseToAnyPublisher()
    }
    
    func watchLeaderboard() -> AnyPublisher<[LeaderboardEntry], Never> {
        let subject = CurrentValueSubject<[LeaderboardEntry], Never>([])
        db.collection("leaderboard")
            .order(by: "xp", descending: true)
            .limit(to: 50)
            .addSnapshotListener { snapshot, _ in
                guard let docs = snapshot?.documents else {
                    subject.send([])
                    return
                }
                let entries = docs.map { LeaderboardEntry(from: $0.data()) }
                subject.send(entries)
            }
        return subject.eraseToAnyPublisher()
    }
    
    func watchAchievements(uid: String) -> AnyPublisher<[Achievement], Never> {
        let subject = CurrentValueSubject<[Achievement], Never>([])
        db.collection("users").document(uid).collection("achievements")
            .order(by: "unlockedAt", descending: true)
            .addSnapshotListener { snapshot, _ in
                guard let docs = snapshot?.documents else {
                    subject.send([])
                    return
                }
                let achs = docs.map { Achievement(from: $0.data(), id: $0.documentID) }
                subject.send(achs)
            }
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Mutations
    
    func logExpense(
        uid: String,
        profile: UserProfile,
        budget: Budget,
        categoryTotal: Double, // current spent in category this month
        amount: Double,
        category: String,
        bankId: String,
        bankName: String,
        note: String
    ) async throws {
        let batch = db.batch()
        
        let expenseRef = db.collection("users").document(uid).collection("expenses").document()
        let expense = Expense(id: expenseRef.documentID, userId: uid, amount: amount, category: category, bankId: bankId, bankName: bankName, note: note, createdAt: Date())
        batch.setData(expense.toDict(), forDocument: expenseRef)
        
        // RPG Calculations
        let categoryLimit = budget.limits[category] ?? 0.0
        let categoryRemaining = categoryLimit - categoryTotal
        let overallRemaining = budget.remainingLimit
        
        let effects = RpgEngine.processExpense(
            amount: amount,
            category: category,
            categoryBudgetRemaining: categoryRemaining,
            overallBudgetRemaining: overallRemaining,
            userClass: profile.userClass
        )
        
        var newProfile = profile
        newProfile.xp += effects.xpGained
        newProfile.gold += effects.goldGained
        newProfile.hp -= effects.hpDamage
        
        // Level up check
        let xpNeeded = RpgEngine.xpForNextLevel(newProfile.level)
        if newProfile.xp >= xpNeeded {
            newProfile.xp -= xpNeeded
            newProfile.level += 1
            newProfile.maxHp = RpgEngine.maxHpForLevel(newProfile.level)
            newProfile.hp = newProfile.maxHp // Heal on level up
        }
        
        if newProfile.hp <= 0 {
            newProfile.hp = 0 // Or handle death
        }
        
        let userRef = db.collection("users").document(uid)
        batch.updateData([
            "xp": newProfile.xp,
            "gold": newProfile.gold,
            "hp": newProfile.hp,
            "level": newProfile.level,
            "maxHp": newProfile.maxHp
        ], forDocument: userRef)
        
        // Update Budget
        let budgetRef = db.collection("users").document(uid).collection("budgets").document(budget.month)
        let newRemaining = budget.remainingLimit - amount
        batch.updateData(["remainingLimit": newRemaining], forDocument: budgetRef)
        
        // Update Leaderboard
        let lbRef = db.collection("leaderboard").document(uid)
        batch.updateData([
            "xp": newProfile.xp,
            "level": newProfile.level
        ], forDocument: lbRef)
        
        // Note: Also update daily quests progress if applicable. (Omitted for brevity, but should fetch today's quest and increment).
        
        try await batch.commit()
    }
    
    func updateBudget(uid: String, limits: [String: Double], bankId: String, budgetType: String) async throws {
        let totalLimit = limits.values.reduce(0, +)
        let budget = Budget(
            userId: uid,
            month: currentMonth,
            totalLimit: totalLimit,
            remainingLimit: totalLimit, // assumes fresh budget
            limits: limits,
            budgetType: budgetType,
            bankId: bankId
        )
        
        let ref = db.collection("users").document(uid).collection("budgets").document(currentMonth)
        try await ref.setData(budget.toDict())
    }
    
    func updateProfile(uid: String, username: String, userClass: String, avatarHair: String, avatarSkin: String) async throws {
        let ref = db.collection("users").document(uid)
        try await ref.updateData([
            "username": username,
            "userClass": userClass,
            "avatarHair": avatarHair,
            "avatarSkin": avatarSkin
        ])
        
        let lbRef = db.collection("leaderboard").document(uid)
        try await lbRef.updateData([
            "username": username,
            "userClass": userClass
        ])
    }
    
    func completeQuest(uid: String, questKey: String) async throws {
        // Get today's quest
        let ref = db.collection("users").document(uid).collection("quests").document(todayString)
        let doc = try await ref.getDocument()
        guard let data = doc.data(), var dailyQuest = Optional(DailyQuest(from: data)) else { return }
        
        var xpReward = 0
        for i in 0..<dailyQuest.quests.count {
            if dailyQuest.quests[i].key == questKey && !dailyQuest.quests[i].completed {
                dailyQuest.quests[i].completed = true
                xpReward = dailyQuest.quests[i].xpReward
                break
            }
        }
        
        guard xpReward > 0 else { return }
        
        let batch = db.batch()
        batch.updateData(["quests": dailyQuest.quests.map { $0.toDict() }], forDocument: ref)
        
        // Add XP
        let userRef = db.collection("users").document(uid)
        batch.updateData(["xp": FieldValue.increment(Int64(xpReward))], forDocument: userRef)
        
        try await batch.commit()
    }
    
    // MARK: - Pagination
    
    func fetchExpensePage(uid: String, after cursor: DocumentSnapshot? = nil, limit: Int = 20) async throws -> ExpensePage {
        var query = db.collection("users").document(uid).collection("expenses")
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            
        if let cursor = cursor {
            query = query.start(afterDocument: cursor)
        }
        
        let snapshot = try await query.getDocuments()
        let items = snapshot.documents.map { Expense(from: $0.data(), id: $0.documentID) }
        let hasMore = items.count == limit
        
        return ExpensePage(items: items, cursor: snapshot.documents.last, hasMore: hasMore)
    }
}
