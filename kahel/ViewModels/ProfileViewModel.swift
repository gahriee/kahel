import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var achievements: [Achievement] = []
    
    private var profileCancellable: AnyCancellable?
    private var achievementsCancellable: AnyCancellable?
    
    func watch(uid: String) {
        profileCancellable = FirestoreService.shared.watchUser(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.profile, on: self)
            
        achievementsCancellable = FirestoreService.shared.watchAchievements(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.achievements, on: self)
    }
}
