import Foundation

struct Achievement: Codable {
    let id: String
    let userId: String
    let achievementKey: String
    let unlockedAt: Date

    init(id: String, userId: String, achievementKey: String, unlockedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.achievementKey = achievementKey
        self.unlockedAt = unlockedAt
    }

    init(from dict: [String: Any], id: String) {
        self.id = id
        self.userId = dict["userId"] as? String ?? ""
        self.achievementKey = dict["achievementKey"] as? String ?? ""
        self.unlockedAt = dict["unlockedAt"] as? Date ?? Date()
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "achievementKey": achievementKey,
            "unlockedAt": unlockedAt
        ]
    }
}
