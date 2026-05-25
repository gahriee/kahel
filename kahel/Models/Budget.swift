import Foundation

struct Budget: Codable {
    let userId: String
    let month: String // "YYYY-MM"
    var totalLimit: Double
    var remainingLimit: Double
    var limits: [String: Double]
    var budgetType: String
    var bankId: String
    var createdAt: Date

    var isWeekly: Bool {
        return budgetType == "weekly"
    }

    var isEmpty: Bool {
        return totalLimit <= 0.0
    }

    var isExpired: Bool {
        guard let endDate = endDate else { return false }
        return Date() > endDate
    }

    var endDate: Date? {
        if isWeekly {
            // Adds 7 days to createdAt
            return Calendar.current.date(byAdding: .day, value: 7, to: createdAt)
        } else {
            // Last day of the current month
            let parts = month.split(separator: "-")
            guard parts.count == 2,
                  let year = Int(parts[0]),
                  let m = Int(parts[1]) else { return nil }
            var comps = DateComponents()
            comps.year = year
            comps.month = m + 1
            comps.day = 0
            return Calendar.current.date(from: comps)
        }
    }

    init(
        userId: String,
        month: String,
        totalLimit: Double,
        remainingLimit: Double,
        limits: [String: Double],
        budgetType: String = "monthly",
        bankId: String = "",
        createdAt: Date = Date()
    ) {
        self.userId = userId
        self.month = month
        self.totalLimit = totalLimit
        self.remainingLimit = remainingLimit
        self.limits = limits
        self.budgetType = budgetType
        self.bankId = bankId
        self.createdAt = createdAt
    }

    init(from dict: [String: Any]) {
        self.userId = dict["userId"] as? String ?? ""
        self.month = dict["month"] as? String ?? ""
        self.totalLimit = (dict["totalLimit"] as? NSNumber)?.doubleValue ?? 0.0
        self.remainingLimit = (dict["remainingLimit"] as? NSNumber)?.doubleValue ?? 0.0
        self.limits = dict["limits"] as? [String: Double] ?? [:]
        self.budgetType = dict["budgetType"] as? String ?? "monthly"
        self.bankId = dict["bankId"] as? String ?? ""
        self.createdAt = dict["createdAt"] as? Date ?? Date()
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "month": month,
            "totalLimit": totalLimit,
            "remainingLimit": remainingLimit,
            "limits": limits,
            "budgetType": budgetType,
            "bankId": bankId,
            "createdAt": createdAt
        ]
    }
}
