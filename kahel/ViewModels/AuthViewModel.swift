
import Foundation
import UIKit
import FirebaseAuth
import Combine

@MainActor
class AuthViewModel: ObservableObject {

    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()

    init() {

        AuthService.shared.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }

    // MARK: Email Sign In

    func signIn(email: String, pass: String) async {

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await AuthService.shared.signInWithEmail(
                email: email,
                password: pass
            )
        } catch {
            self.error = error
        }
    }

    // MARK: Email Sign Up

    func signUp(email: String, pass: String) async {

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await AuthService.shared.signUpWithEmail(
                email: email,
                password: pass
            )
        } catch {
            self.error = error
        }
    }

    // MARK: Google Sign In

    func signInWithGoogle(
        presenting viewController: UIViewController
    ) async {

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await AuthService.shared.signInWithGoogle(
                presenting: viewController
            )
        } catch {
            self.error = error
        }
    }

    // MARK: Sign Out

    func signOut() {

        do {
            try AuthService.shared.signOut()
        } catch {
            self.error = error
        }
    }
}
