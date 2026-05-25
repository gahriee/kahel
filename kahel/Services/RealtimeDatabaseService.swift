import Foundation
import FirebaseDatabase
import FirebaseStorage
import Combine

class RealtimeDatabaseService {
    static let shared = RealtimeDatabaseService()
    
    private let db = Database.database(url: "https://kahel-5f4fb-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    // MARK: - Bank Accounts
    
    func watchBanks(uid: String) -> AnyPublisher<[BankAccount], Never> {
        let subject = CurrentValueSubject<[BankAccount], Never>([])
        
        let ref = db.child("banks").child(uid)
        ref.observe(.value) { snapshot in
            guard let dict = snapshot.value as? [String: [String: Any]] else {
                subject.send([])
                return
            }
            
            var banks: [BankAccount] = []
            for (key, value) in dict {
                let bank = BankAccount(from: value, id: key)
                banks.append(bank)
            }
            
            // Sort by latest updated
            banks.sort { $0.lastUpdated > $1.lastUpdated }
            subject.send(banks)
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func updateBank(bank: BankAccount) async throws {
        let ref = db.child("banks").child(bank.userId).child(bank.id)
        var dict = bank.toDict()
        dict["lastUpdated"] = ServerValue.timestamp()
        try await ref.setValue(dict)
    }
    
    func deleteBank(uid: String, bankId: String) async throws {
        let ref = db.child("banks").child(uid).child(bankId)
        try await ref.removeValue()
    }
    
    func adjustBankBalance(uid: String, bankId: String, delta: Double) async throws {
        let ref = db.child("banks").child(uid).child(bankId)
        
        return try await withCheckedThrowingContinuation { continuation in
            ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                var dict = currentData.value as? [String: Any] ?? [:]
                let currentBalance = (dict["balance"] as? NSNumber)?.doubleValue ?? 0.0
                dict["balance"] = currentBalance + delta
                dict["lastUpdated"] = ServerValue.timestamp()
                
                currentData.value = dict
                return TransactionResult.success(withValue: currentData)
            }) { error, committed, snapshot in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if !committed {
                    continuation.resume(throwing: NSError(domain: "RTDB", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transaction not committed"]))
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // MARK: - Avatar Metadata
    
    func writeProfileAvatarMeta(uid: String, avatarUrl: String) async throws {
        // Write to RTDB directly
        try await db.child("user_avatars").child(uid).setValue(["url": avatarUrl])
        
        // If we also needed to upload to storage, we could download the SVG and upload it.
        // But the Flutter app just writes the URL to RTDB or downloads it.
    }
}
