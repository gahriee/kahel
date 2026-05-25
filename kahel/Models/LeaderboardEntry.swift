import Foundation

struct LeaderboardEntry: Codable {
    let uid: String
    var username: String
    var level: Int
    var xp: Int
    var weeklyXp: Int
    var userClass: String
    var avatarUrl: String
    var streakDays: Int

    init(
        uid: String,
        username: String,
        level: Int,
        xp: Int,
        weeklyXp: Int,
        userClass: String,
        avatarUrl: String,
        streakDays: Int
    ) {
        self.uid = uid
        self.username = username
        self.level = level
        self.xp = xp
        self.weeklyXp = weeklyXp
        self.userClass = userClass
        self.avatarUrl = avatarUrl
        self.streakDays = streakDays
    }

    init(from dict: [String: Any]) {
        self.uid = dict["uid"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.level = dict["level"] as? Int ?? 1
        self.xp = dict["xp"] as? Int ?? 0
        self.weeklyXp = dict["weeklyXp"] as? Int ?? 0
        self.userClass = dict["userClass"] as? String ?? "Saver"
        self.avatarUrl = dict["avatarUrl"] as? String ?? ""
        self.streakDays = dict["streakDays"] as? Int ?? 0
    }

    func toDict() -> [String: Any] {
        return [
            "uid": uid,
            "username": username,
            "level": level,
            "xp": xp,
            "weeklyXp": weeklyXp,
            "userClass": userClass,
            "avatarUrl": avatarUrl,
            "streakDays": streakDays
        ]
    }
}
