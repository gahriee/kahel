import Foundation
import Combine

@MainActor
class QuestViewModel: ObservableObject {
    @Published var dailyQuest: DailyQuest?
    
    private var cancellable: AnyCancellable?
    
    func watch(uid: String) {
        cancellable = FirestoreService.shared.watchTodayQuests(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.dailyQuest, on: self)
    }
    
    func completeQuest(uid: String, questKey: String) async {
        try? await FirestoreService.shared.completeQuest(uid: uid, questKey: questKey)
    }
}
