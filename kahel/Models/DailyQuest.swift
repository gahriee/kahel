import Foundation

struct QuestEntry: Codable {
    let key: String
    let label: String
    var target: Int
    var progress: Int
    let xpReward: Int
    var completed: Bool

    init(
        key: String,
        label: String,
        target: Int,
        progress: Int,
        xpReward: Int,
        completed: Bool
    ) {
        self.key = key
        self.label = label
        self.target = target
        self.progress = progress
        self.xpReward = xpReward
        self.completed = completed
    }

    init(from dict: [String: Any]) {
        self.key = dict["key"] as? String ?? ""
        self.label = dict["label"] as? String ?? ""
        self.target = dict["target"] as? Int ?? 1
        self.progress = dict["progress"] as? Int ?? 0
        self.xpReward = dict["xpReward"] as? Int ?? 0
        self.completed = dict["completed"] as? Bool ?? false
    }

    func toDict() -> [String: Any] {
        return [
            "key": key,
            "label": label,
            "target": target,
            "progress": progress,
            "xpReward": xpReward,
            "completed": completed
        ]
    }
}

struct DailyQuest: Codable {
    let userId: String
    let date: String // "YYYY-MM-DD"
    var quests: [QuestEntry]
    let createdAt: Date

    init(
        userId: String,
        date: String,
        quests: [QuestEntry],
        createdAt: Date = Date()
    ) {
        self.userId = userId
        self.date = date
        self.quests = quests
        self.createdAt = createdAt
    }

    init(from dict: [String: Any]) {
        self.userId = dict["userId"] as? String ?? ""
        self.date = dict["date"] as? String ?? ""
        
        let questsRaw = dict["quests"] as? [[String: Any]] ?? []
        self.quests = questsRaw.map { QuestEntry(from: $0) }
        
        self.createdAt = dict["createdAt"] as? Date ?? Date()
    }

    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "date": date,
            "quests": quests.map { $0.toDict() },
            "createdAt": createdAt
        ]
    }
}
