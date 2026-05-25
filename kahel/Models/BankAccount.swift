import Foundation

struct BankAccount: Codable {
    let id: String
    let userId: String
    var bankName: String
    var balance: Double
    var savingsGoal: Double
    var isEmergencyFund: Bool
    var lastUpdated: Date

    var progress: Double {
        if savingsGoal <= 0 { return 1.0 }
        return min(balance / savingsGoal, 1.0)
    }

    init(
        id: String,
        userId: String,
        bankName: String,
        balance: Double = 0.0,
        savingsGoal: Double = 0.0,
        isEmergencyFund: Bool = false,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.bankName = bankName
        self.balance = balance
        self.savingsGoal = savingsGoal
        self.isEmergencyFund = isEmergencyFund
        self.lastUpdated = lastUpdated
    }

    init(from dict: [String: Any], id: String) {
        self.id = id
        self.userId = dict["userId"] as? String ?? ""
        self.bankName = dict["bankName"] as? String ?? ""
        self.balance = (dict["balance"] as? NSNumber)?.doubleValue ?? 0.0
        self.savingsGoal = (dict["savingsGoal"] as? NSNumber)?.doubleValue ?? 0.0
        self.isEmergencyFund = dict["isEmergencyFund"] as? Bool ?? false
        
        if let epoch = dict["lastUpdated"] as? TimeInterval {
            // Realtime database usually stores epoch ms
            self.lastUpdated = Date(timeIntervalSince1970: epoch / 1000.0)
        } else {
            self.lastUpdated = Date()
        }
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "bankName": bankName,
            "balance": balance,
            "savingsGoal": savingsGoal,
            "isEmergencyFund": isEmergencyFund,
            "lastUpdated": lastUpdated.timeIntervalSince1970 * 1000 // ms
        ]
    }
}
