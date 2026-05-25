import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var expenses: [Expense] = []
    @Published var budget: Budget?
    
    private var profileCancellable: AnyCancellable?
    private var expensesCancellable: AnyCancellable?
    private var budgetCancellable: AnyCancellable?
    
    func watch(uid: String) {
        profileCancellable = FirestoreService.shared.watchUser(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.profile, on: self)
            
        expensesCancellable = FirestoreService.shared.watchExpenses(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.expenses, on: self)
            
        budgetCancellable = FirestoreService.shared.watchBudget(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.budget, on: self)
    }
    
    var categoryTotals: [String: Double] {
        var totals = defaultBudgetLimits
        for expense in expenses {
            // Only sum up expenses for the current month
            // We assume watchExpenses gives recent, but we filter to be safe
            if expense.createdAt >= startOfMonth() {
                let cat = expense.category
                totals[cat] = (totals[cat] ?? 0.0) + expense.amount
            }
        }
        return totals
    }
    
    private func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    }
}
