import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private let authViewModel = AuthViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let titleLabel = UILabel()
    private let emailField = PixelTextField()
    private let passField = PixelTextField()
    private let loginButton = PixelButton()
    private let googleButton = PixelButton()
    private let signupButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        navigationItem.hidesBackButton = true
        
        titleLabel.text = "WELCOME\nBACK"
        titleLabel.font = AppFonts.pixel(size: 20)
        titleLabel.textColor = AppColors.accent
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.title = "EMAIL"
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        passField.title = "PASSWORD"
        passField.textField.isSecureTextEntry = true
        passField.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.title = "▶ LOGIN"
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        googleButton.title = "G  GOOGLE"
        googleButton.color = AppColors.surfaceAlt(for: traitCollection)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.addTarget(self, action: #selector(handleGoogle), for: .touchUpInside)
        
        signupButton.setTitle("NO ACCOUNT? SIGN UP »", for: .normal)
        signupButton.titleLabel?.font = AppFonts.pixel(size: 7)
        signupButton.setTitleColor(AppColors.textDim(for: traitCollection), for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, emailField, passField, loginButton, googleButton, signupButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.setCustomSpacing(40, after: titleLabel)
        stack.setCustomSpacing(12, after: loginButton)
        stack.setCustomSpacing(32, after: googleButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func bindViewModel() {
        authViewModel.$isLoading.sink { [weak self] loading in
            self?.loginButton.isLoading = loading
            self?.googleButton.isLoading = loading
        }.store(in: &cancellables)
        
        authViewModel.$error.sink { [weak self] error in
            if let error = error {
                PixelToast.show(message: error.localizedDescription, success: false)
            }
        }.store(in: &cancellables)
        
        authViewModel.$currentUser.sink { [weak self] user in
            if user != nil {
                let vc = DashboardViewController()
                self?.navigationController?.setViewControllers([vc], animated: true)
            }
        }.store(in: &cancellables)
    }
    
    @objc private func handleLogin() {
        guard let email = emailField.textField.text, !email.isEmpty,
              let pass = passField.textField.text, !pass.isEmpty else {
            PixelToast.show(message: "Fields cannot be empty", success: false)
            return
        }
        Task {
            await authViewModel.signIn(email: email, pass: pass)
        }
    }
    
    @objc private func handleGoogle() {
        Task {
            await authViewModel.signInWithGoogle(presenting: self)
        }
    }
    
    @objc private func handleSignup() {
        let vc = SignupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
