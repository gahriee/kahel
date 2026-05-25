import Foundation

struct UserProfile: Codable {
    let uid: String
    let email: String
    var username: String
    var userClass: String
    var avatarHair: String
    var avatarSkin: String
    var level: Int
    var xp: Int
    var hp: Int
    var gold: Int
    var maxHp: Int
    var streakDays: Int
    var lastLogin: Date
    var createdAt: Date

    var hpPercent: Int {
        if maxHp <= 0 { return 100 }
        return max(0, min(100, Int((Double(hp) / Double(maxHp)) * 100)))
    }

    init(
        uid: String,
        email: String,
        username: String,
        userClass: String = "Saver",
        avatarHair: String = "short01",
        avatarSkin: String = "variant01",
        level: Int = 1,
        xp: Int = 0,
        hp: Int = 100,
        gold: Int = 0,
        maxHp: Int = 100,
        streakDays: Int = 1,
        lastLogin: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.uid = uid
        self.email = email
        self.username = username
        self.userClass = userClass
        self.avatarHair = avatarHair
        self.avatarSkin = avatarSkin
        self.level = level
        self.xp = xp
        self.hp = hp
        self.gold = gold
        self.maxHp = maxHp
        self.streakDays = streakDays
        self.lastLogin = lastLogin
        self.createdAt = createdAt
    }

    init(from dict: [String: Any]) {
        self.uid = dict["uid"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.userClass = dict["userClass"] as? String ?? "Saver"
        self.avatarHair = dict["avatarHair"] as? String ?? "short01"
        self.avatarSkin = dict["avatarSkin"] as? String ?? "variant01"
        self.level = dict["level"] as? Int ?? 1
        self.xp = dict["xp"] as? Int ?? 0
        self.hp = dict["hp"] as? Int ?? 100
        self.gold = dict["gold"] as? Int ?? 0
        self.maxHp = dict["maxHp"] as? Int ?? 100
        self.streakDays = dict["streakDays"] as? Int ?? 1
        
        // Handle Firestore Timestamps
        if let ts = dict["lastLogin"] as? /* Timestamp */ Any {
            // Need to safely cast if using FirebaseFirestore
            // We will do date casting in FirestoreService or using Timestamp.dateValue()
            // Assuming dict already has Date objects converted for simplicity here,
            // or we handle conversion in the service layer.
            self.lastLogin = ts as? Date ?? Date()
        } else {
            self.lastLogin = Date()
        }
        
        if let ts = dict["createdAt"] as? Any {
            self.createdAt = ts as? Date ?? Date()
        } else {
            self.createdAt = Date()
        }
    }

    func toDict() -> [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "username": username,
            "userClass": userClass,
            "avatarHair": avatarHair,
            "avatarSkin": avatarSkin,
            "level": level,
            "xp": xp,
            "hp": hp,
            "gold": gold,
            "maxHp": maxHp,
            "streakDays": streakDays,
            "lastLogin": lastLogin, // FirestoreService converts Date to Timestamp
            "createdAt": createdAt
        ]
    }
}
