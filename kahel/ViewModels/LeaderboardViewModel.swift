import Foundation
import Combine

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    
    private var cancellable: AnyCancellable?
    
    // Dummy entries for visual testing, matching Flutter implementation
    private let dummyEntries = [
        LeaderboardEntry(uid: "codex", username: "Codex", level: 9, xp: 7420, weeklyXp: 880, userClass: "Hustler", avatarUrl: AvatarService.getAvatarUrl(seed: "codex", hpPercent: 90), streakDays: 21),
        LeaderboardEntry(uid: "dummy_kahel_knight", username: "KahelKnight", level: 7, xp: 5380, weeklyXp: 640, userClass: "Saver", avatarUrl: AvatarService.getAvatarUrl(seed: "dummy_kahel_knight"), streakDays: 14),
        LeaderboardEntry(uid: "dummy_budget_mage", username: "BudgetMage", level: 6, xp: 4210, weeklyXp: 520, userClass: "Minimalist", avatarUrl: AvatarService.getAvatarUrl(seed: "dummy_budget_mage"), streakDays: 9),
        LeaderboardEntry(uid: "dummy_bpi_ranger", username: "BPIRanger", level: 5, xp: 3050, weeklyXp: 410, userClass: "Saver", avatarUrl: AvatarService.getAvatarUrl(seed: "dummy_bpi_ranger"), streakDays: 8)
    ]
    
    func watch() {
        cancellable = FirestoreService.shared.watchLeaderboard()
            .receive(on: RunLoop.main)
            .sink { [weak self] liveEntries in
                guard let self = self else { return }
                var all = liveEntries
                for dummy in self.dummyEntries {
                    if !all.contains(where: { $0.uid == dummy.uid }) {
                        all.append(dummy)
                    }
                }
                all.sort { $0.xp > $1.xp }
                self.entries = all
            }
    }
}
