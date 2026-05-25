import UIKit

class OnboardingViewController: UIViewController {
    
    let heroClass: String
    
    init(heroClass: String) {
        self.heroClass = heroClass
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.bg(for: traitCollection)
        
        let label = UILabel()
        label.text = "ONBOARDING\nCLASS: \(heroClass)"
        label.font = AppFonts.pixel(size: 20)
        label.textColor = AppColors.accent
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let finishButton = PixelButton()
        finishButton.title = "FINISH"
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
        view.addSubview(finishButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            finishButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func finishOnboarding() {
        let vc = DashboardViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}
