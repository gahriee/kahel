import Foundation

struct MonthlyAllocation: Codable {
    let id: String
    let userId: String
    let month: String
    let bankId: String
    let category: String
    let allocatedAmount: Double
    var spentAmount: Double
    let createdAt: Date

    var remainingAmount: Double {
        return allocatedAmount - spentAmount
    }

    init(
        id: String,
        userId: String,
        month: String,
        bankId: String,
        category: String,
        allocatedAmount: Double,
        spentAmount: Double = 0.0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.month = month
        self.bankId = bankId
        self.category = category
        self.allocatedAmount = allocatedAmount
        self.spentAmount = spentAmount
        self.createdAt = createdAt
    }

    init(from dict: [String: Any], id: String) {
        self.id = id
        self.userId = dict["userId"] as? String ?? ""
        self.month = dict["month"] as? String ?? ""
        self.bankId = dict["bankId"] as? String ?? ""
        self.category = dict["category"] as? String ?? ""
        self.allocatedAmount = (dict["allocatedAmount"] as? NSNumber)?.doubleValue ?? 0.0
        self.spentAmount = (dict["spentAmount"] as? NSNumber)?.doubleValue ?? 0.0
        self.createdAt = dict["createdAt"] as? Date ?? Date()
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "month": month,
            "bankId": bankId,
            "category": category,
            "allocatedAmount": allocatedAmount,
            "spentAmount": spentAmount,
            "createdAt": createdAt
        ]
    }
}
