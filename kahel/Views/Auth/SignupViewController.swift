import UIKit
import Combine

class SignupViewController: UIViewController {
    
    private let authViewModel = AuthViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let titleLabel = UILabel()
    private let emailField = PixelTextField()
    private let passField = PixelTextField()
    private let classSegment = UISegmentedControl(items: ["SAVER", "MINIMALIST", "HUSTLER"])
    private let signupButton = PixelButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        
        titleLabel.text = "NEW HERO"
        titleLabel.font = AppFonts.pixel(size: 20)
        titleLabel.textColor = AppColors.accent
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.title = "EMAIL"
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        passField.title = "PASSWORD"
        passField.textField.isSecureTextEntry = true
        passField.translatesAutoresizingMaskIntoConstraints = false
        
        classSegment.selectedSegmentIndex = 0
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFonts.pixel(size: 7)
        ]
        classSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
        classSegment.translatesAutoresizingMaskIntoConstraints = false
        
        signupButton.title = "▶ SIGN UP"
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, emailField, passField, classSegment, signupButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.setCustomSpacing(40, after: titleLabel)
        stack.setCustomSpacing(32, after: classSegment)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            classSegment.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func bindViewModel() {
        authViewModel.$isLoading.sink { [weak self] loading in
            self?.signupButton.isLoading = loading
        }.store(in: &cancellables)
        
        authViewModel.$error.sink { [weak self] error in
            if let error = error {
                PixelToast.show(message: error.localizedDescription, success: false)
            }
        }.store(in: &cancellables)
        
        authViewModel.$currentUser.sink { [weak self] user in
            guard let self = self, let user = user else { return }
            let selectedClass = self.classSegment.titleForSegment(at: self.classSegment.selectedSegmentIndex)?.capitalized ?? "Saver"
            
            let vc = OnboardingViewController(heroClass: selectedClass)
            self.navigationController?.setViewControllers([vc], animated: true)
        }.store(in: &cancellables)
    }
    
    @objc private func handleSignup() {
        guard let email = emailField.textField.text, !email.isEmpty,
              let pass = passField.textField.text, !pass.isEmpty else {
            PixelToast.show(message: "Fields cannot be empty", success: false)
            return
        }
        Task {
            await authViewModel.signUp(email: email, pass: pass)
        }
    }
}
