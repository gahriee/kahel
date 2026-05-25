import Foundation

struct WeeklyAllocation: Codable {
    let id: String
    let userId: String
    let weekId: String
    let bankId: String
    let category: String
    let allocatedAmount: Double
    var spentAmount: Double
    let startDate: Date
    let endDate: Date

    var remainingAmount: Double {
        return allocatedAmount - spentAmount
    }

    init(
        id: String,
        userId: String,
        weekId: String,
        bankId: String,
        category: String,
        allocatedAmount: Double,
        spentAmount: Double = 0.0,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.userId = userId
        self.weekId = weekId
        self.bankId = bankId
        self.category = category
        self.allocatedAmount = allocatedAmount
        self.spentAmount = spentAmount
        self.startDate = startDate
        self.endDate = endDate
    }

    init(from dict: [String: Any], id: String) {
        self.id = id
        self.userId = dict["userId"] as? String ?? ""
        self.weekId = dict["weekId"] as? String ?? ""
        self.bankId = dict["bankId"] as? String ?? ""
        self.category = dict["category"] as? String ?? ""
        self.allocatedAmount = (dict["allocatedAmount"] as? NSNumber)?.doubleValue ?? 0.0
        self.spentAmount = (dict["spentAmount"] as? NSNumber)?.doubleValue ?? 0.0
        self.startDate = dict["startDate"] as? Date ?? Date()
        self.endDate = dict["endDate"] as? Date ?? Date()
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "weekId": weekId,
            "bankId": bankId,
            "category": category,
            "allocatedAmount": allocatedAmount,
            "spentAmount": spentAmount,
            "startDate": startDate,
            "endDate": endDate
        ]
    }
}
