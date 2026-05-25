import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import Combine

class AuthService: ObservableObject {

    static let shared = AuthService()

    @Published var currentUser: User?
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    private init() {

        // Listen for auth changes
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: Email Sign Up

    func signUpWithEmail(email: String, password: String) async throws -> User {

        let result = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )

        return result.user
    }

    // MARK: Email Sign In

    func signInWithEmail(email: String, password: String) async throws -> User {

        let result = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )

        return result.user
    }

    // MARK: Google Sign In

    func signInWithGoogle(
        presenting viewController: UIViewController
    ) async throws -> User {

        let gidResult = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: viewController
        )

        guard let idToken = gidResult.user.idToken?.tokenString else {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "No ID Token Found"
                ]
            )
        }

        let accessToken = gidResult.user.accessToken.tokenString

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )

        let authResult = try await Auth.auth().signIn(with: credential)

        return authResult.user
    }

    // MARK: Sign Out

    func signOut() throws {

        GIDSignIn.sharedInstance.signOut()

        try Auth.auth().signOut()
    }
}
