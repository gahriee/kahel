import Foundation
import Combine

@MainActor
class SavingsViewModel: ObservableObject {
    @Published var banks: [BankAccount] = []
    @Published var isHidden: Bool = true // Privacy toggle
    
    private var cancellable: AnyCancellable?
    
    func watch(uid: String) {
        cancellable = RealtimeDatabaseService.shared.watchBanks(uid: uid)
            .receive(on: RunLoop.main)
            .assign(to: \.banks, on: self)
    }
    
    func togglePrivacy() {
        isHidden.toggle()
    }
}
