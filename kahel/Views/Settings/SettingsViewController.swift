import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Settings"
        
        let logoutButton = PixelButton()
        logoutButton.title = "LOGOUT"
        logoutButton.color = AppColors.danger
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func handleLogout() {
        try? AuthService.shared.signOut()
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
