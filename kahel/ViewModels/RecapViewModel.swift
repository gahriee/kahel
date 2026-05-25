import Foundation
import Combine

@MainActor
class RecapViewModel: ObservableObject {
    @Published var weekTotal: Double = 0.0
    @Published var topCategory: String = "None"
    @Published var logCount: Int = 0
    @Published var flavorText: String = "A quiet week in the ledger."
    
    private var cancellable: AnyCancellable?
    
    func watch(uid: String) {
        cancellable = FirestoreService.shared.watchExpenses(uid: uid)
            .receive(on: RunLoop.main)
            .sink { [weak self] expenses in
                self?.calculate(expenses: expenses)
            }
    }
    
    private func calculate(expenses: [Expense]) {
        let weekStart = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let weekExpenses = expenses.filter { $0.createdAt >= weekStart }
        
        self.logCount = weekExpenses.count
        self.weekTotal = weekExpenses.reduce(0.0) { $0 + $1.amount }
        
        var totals: [String: Double] = [:]
        for e in weekExpenses {
            totals[e.category] = (totals[e.category] ?? 0) + e.amount
        }
        
        if let top = totals.max(by: { $0.value < $1.value }) {
            self.topCategory = top.key
        } else {
            self.topCategory = "None"
        }
        
        self.flavorText = flavor(category: self.topCategory)
    }
    
    private func flavor(category: String) -> String {
        switch category {
        case "Food": return "Food spending took the biggest bite."
        case "Shopping": return "Shopping claimed the most gold."
        case "Subscriptions": return "Subscriptions kept nibbling quietly."
        case "Transport": return "You traveled far this week."
        case "Savings": return "Savings carried the run."
        default: return "A quiet week in the ledger."
        }
    }
}
