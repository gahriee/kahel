import UIKit
import Combine

class DashboardViewController: UIViewController {
    
    private let viewModel = DashboardViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let titleLabel = UILabel()
    private let statsLabel = UILabel()
    private let avatarView = AdventurerAvatarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        if let user = AuthService.shared.currentUser {
            viewModel.watch(uid: user.uid)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        navigationItem.title = "KAHEL"
        
        // Navigation bar buttons
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addExpense)),
            UIBarButtonItem(image: UIImage(systemName: "crown"), style: .plain, target: self, action: #selector(openLeaderboard))
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(openDrawer))
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarView)
        
        titleLabel.font = AppFonts.pixel(size: 16)
        titleLabel.textColor = AppColors.accent
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        statsLabel.font = AppFonts.body(size: 14)
        statsLabel.textColor = AppColors.text(for: traitCollection)
        statsLabel.numberOfLines = 0
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$profile.sink { [weak self] profile in
            guard let profile = profile else { return }
            self?.titleLabel.text = profile.username.uppercased()
            self?.statsLabel.text = """
            Level: \(profile.level) - \(profile.userClass)
            HP: \(profile.hp)/\(profile.maxHp)
            XP: \(profile.xp)
            Gold: \(profile.gold)
            """
            
            self?.avatarView.uid = profile.uid
            self?.avatarView.hair = profile.avatarHair
            self?.avatarView.skinColor = profile.avatarSkin
            self?.avatarView.hpPercent = profile.hpPercent
        }.store(in: &cancellables)
    }
    
    @objc private func openLeaderboard() {
        navigationController?.pushViewController(LeaderboardViewController(), animated: true)
    }
    
    @objc private func addExpense() {
        let vc = AddExpenseViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    @objc private func openDrawer() {
        // Basic implementation to navigate to settings or logout for now
        let actionSheet = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Profile", style: .default) { _ in
            self.navigationController?.pushViewController(ProfileViewController(), animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Savings", style: .default) { _ in
            self.navigationController?.pushViewController(SavingsViewController(), animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Quests", style: .default) { _ in
            self.navigationController?.pushViewController(QuestViewController(), animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Logs", style: .default) { _ in
            self.navigationController?.pushViewController(LogsViewController(), animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Weekly Recap", style: .default) { _ in
            self.navigationController?.pushViewController(WeeklyRecapViewController(), animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            self.navigationController?.pushViewController(SettingsViewController(), animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            try? AuthService.shared.signOut()
            self.navigationController?.setViewControllers([LoginViewController()], animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}
