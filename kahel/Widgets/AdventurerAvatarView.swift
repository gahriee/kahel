import UIKit
import SVGKit

class AdventurerAvatarView: UIView {
    
    var uid: String = ""
    var hair: String = "short01"
    var skinColor: String = "variant01"
    var hpPercent: Int = 100 {
        didSet {
            updateAvatar()
            if hpPercent <= 25 && oldValue > 25 {
                shake()
            }
        }
    }
    
    private let imageView = UIImageView()
    private let damageOverlay = UIView()
    private var currentTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        damageOverlay.backgroundColor = UIColor.red.withAlphaComponent(0.0)
        damageOverlay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(damageOverlay)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            damageOverlay.topAnchor.constraint(equalTo: topAnchor),
            damageOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            damageOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            damageOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func updateAvatar() {
        guard !uid.isEmpty else { return }
        let url = AvatarService.getAvatarUrl(seed: uid, hair: hair, skinColor: skinColor, hpPercent: hpPercent)
        
        currentTask?.cancel()
        currentTask = Task {
            do {
                let image = try await AvatarService.loadAvatarSVG(url: url)
                if !Task.isCancelled {
                    self.imageView.image = image
                }
            } catch {
                print("Failed to load avatar: \(error)")
            }
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-5.0, 5.0, -5.0, 5.0, -3.0, 3.0, -1.0, 1.0, 0.0]
        layer.add(animation, forKey: "shake")
        
        UIView.animate(withDuration: 0.1, animations: {
            self.damageOverlay.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        }) { _ in
            UIView.animate(withDuration: 0.4) {
                self.damageOverlay.backgroundColor = UIColor.red.withAlphaComponent(0.0)
            }
        }
    }
}
