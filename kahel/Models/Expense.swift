import Foundation

struct Expense: Codable, Identifiable {
    let id: String
    let userId: String
    let amount: Double
    let category: String
    let bankId: String
    let bankName: String
    let note: String
    let createdAt: Date

    init(
        id: String,
        userId: String,
        amount: Double,
        category: String,
        bankId: String = "",
        bankName: String = "",
        note: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.category = category
        self.bankId = bankId
        self.bankName = bankName
        self.note = note
        self.createdAt = createdAt
    }

    init(from dict: [String: Any], id: String) {
        self.id = id
        self.userId = dict["userId"] as? String ?? ""
        self.amount = (dict["amount"] as? NSNumber)?.doubleValue ?? 0.0
        self.category = dict["category"] as? String ?? "Other"
        self.bankId = dict["bankId"] as? String ?? ""
        self.bankName = dict["bankName"] as? String ?? ""
        self.note = dict["note"] as? String ?? ""
        self.createdAt = dict["createdAt"] as? Date ?? Date()
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "amount": amount,
            "category": category,
            "bankId": bankId,
            "bankName": bankName,
            "note": note,
            "createdAt": createdAt
        ]
    }
}
