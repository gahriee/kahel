import UIKit

class PixelToast {
    static func show(message: String, success: Bool) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        let container = UIView()
        container.backgroundColor = success ? AppColors.success : AppColors.danger
        container.layer.cornerRadius = 2
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.white.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        iconContainer.layer.cornerRadius = 2
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: success ? "checkmark" : "xmark")
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(iconView)
        
        let label = UILabel()
        label.text = message
        label.font = AppFonts.pixel(size: 7)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconContainer)
        container.addSubview(label)
        
        window.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 32),
            iconContainer.heightAnchor.constraint(equalToConstant: 32),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            label.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14)
        ])
        
        container.alpha = 0
        container.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.3, animations: {
            container.alpha = 1
            container.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 3.0, options: .curveEaseIn, animations: {
                container.alpha = 0
                container.transform = CGAffineTransform(translationX: 0, y: 20)
            }) { _ in
                container.removeFromSuperview()
            }
        }
    }
}
