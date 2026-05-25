import UIKit
import Combine

class ProfileViewController: UIViewController {
    private let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let avatarView = AdventurerAvatarView()
    private let nameLabel = UILabel()
    private let classLabel = UILabel()
    private let statsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let user = AuthService.shared.currentUser {
            viewModel.watch(uid: user.uid)
        }
        
        viewModel.$profile.sink { [weak self] profile in
            guard let profile = profile else { return }
            self?.avatarView.uid = profile.uid
            self?.avatarView.hair = profile.avatarHair
            self?.avatarView.skinColor = profile.avatarSkin
            self?.avatarView.hpPercent = profile.hpPercent
            
            self?.nameLabel.text = profile.username.uppercased()
            self?.classLabel.text = "CLASS: \(profile.userClass)"
            self?.statsLabel.text = """
            Level \(profile.level)
            XP: \(profile.xp) / \(RpgEngine.xpForNextLevel(profile.level))
            HP: \(profile.hp) / \(profile.maxHp)
            Gold: \(profile.gold)
            Streak: \(profile.streakDays) Days
            """
        }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        title = "Profile"
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        classLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = AppFonts.pixel(size: 20)
        nameLabel.textColor = AppColors.accent
        nameLabel.textAlignment = .center
        
        classLabel.font = AppFonts.pixel(size: 10)
        classLabel.textColor = AppColors.textDim(for: traitCollection)
        classLabel.textAlignment = .center
        
        statsLabel.font = AppFonts.body(size: 16)
        statsLabel.textColor = AppColors.text(for: traitCollection)
        statsLabel.numberOfLines = 0
        statsLabel.textAlignment = .center
        
        view.addSubview(avatarView)
        view.addSubview(nameLabel)
        view.addSubview(classLabel)
        view.addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            avatarView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            classLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            classLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statsLabel.topAnchor.constraint(equalTo: classLabel.bottomAnchor, constant: 32),
            statsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
