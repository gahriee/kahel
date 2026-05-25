import UIKit

class SplashViewController: UIViewController {
    
    private let starField = PixelStarField(starCount: 60)
    private let scanline = ScanlineOverlay()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let pressStartLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateEntry()
        
        // Simulate loading time before moving to next screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.checkAuth()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.bg(for: traitCollection)
        
        starField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starField)
        
        scanline.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanline)
        
        titleLabel.text = "KAHEL"
        titleLabel.font = AppFonts.pixel(size: 32)
        titleLabel.textColor = AppColors.accent
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.text = "FINANCE ADVENTURE"
        subtitleLabel.font = AppFonts.pixel(size: 8)
        subtitleLabel.textColor = AppColors.textDim(for: traitCollection)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pressStartLabel.text = "PRESS START"
        pressStartLabel.font = AppFonts.pixel(size: 10)
        pressStartLabel.textColor = AppColors.gold
        pressStartLabel.textAlignment = .center
        pressStartLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(pressStartLabel)
        
        NSLayoutConstraint.activate([
            starField.topAnchor.constraint(equalTo: view.topAnchor),
            starField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            starField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scanline.topAnchor.constraint(equalTo: view.topAnchor),
            scanline.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scanline.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scanline.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pressStartLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            pressStartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func animateEntry() {
        titleLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        titleLabel.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.titleLabel.transform = .identity
            self.titleLabel.alpha = 1
        })
        
        subtitleLabel.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
            self.subtitleLabel.alpha = 1
        })
        
        // Blink "PRESS START"
        UIView.animate(withDuration: 0.8, delay: 0.8, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.pressStartLabel.alpha = 0
        })
    }
    
    private func checkAuth() {
        // Simple auth check simulation, should use AuthViewModel
        if AuthService.shared.currentUser != nil {
            let vc = DashboardViewController()
            navigationController?.setViewControllers([vc], animated: true)
        } else {
            let vc = LoginViewController()
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
