import Foundation

struct QuestDef {
    let key: String
    let label: String
    let baseTarget: Int
    let baseReward: Int
}

let questPool: [QuestDef] = [
    QuestDef(key: "log_food", label: "Log 1 Food Expense", baseTarget: 1, baseReward: 20),
    QuestDef(key: "log_transport", label: "Log 1 Transport Expense", baseTarget: 1, baseReward: 20),
    QuestDef(key: "save_money", label: "Log Savings", baseTarget: 1, baseReward: 50),
    QuestDef(key: "log_any", label: "Log 3 Expenses", baseTarget: 3, baseReward: 40),
    QuestDef(key: "no_shopping", label: "No Shopping Today", baseTarget: 0, baseReward: 30),
    QuestDef(key: "early_bird", label: "Log Before 10 AM", baseTarget: 1, baseReward: 25)
]
