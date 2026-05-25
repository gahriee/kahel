import Foundation

let expenseCategories = [
    "Food",
    "Transport",
    "Shopping",
    "Subscriptions",
    "Utilities",
    "Entertainment",
    "Savings",
    "Other"
]

let defaultBudgetLimits: [String: Double] = expenseCategories.reduce(into: [:]) { result, category in
    result[category] = 0.0
}
