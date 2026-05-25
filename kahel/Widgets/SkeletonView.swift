import UIKit

class SkeletonView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 4
        clipsToBounds = true
        
        let darkColor = UIColor.white.withAlphaComponent(0.05).cgColor
        let lightColor = UIColor.white.withAlphaComponent(0.15).cgColor
        
        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "skeletonAnimation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let isDark = traitCollection.userInterfaceStyle == .dark
        let darkColor = (isDark ? UIColor.white : UIColor.black).withAlphaComponent(0.05).cgColor
        let lightColor = (isDark ? UIColor.white : UIColor.black).withAlphaComponent(0.15).cgColor
        gradientLayer.colors = [darkColor, lightColor, darkColor]
    }
}
