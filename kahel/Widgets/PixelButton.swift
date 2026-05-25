import UIKit

class PixelButton: UIControl {
    
    private let titleLabel = UILabel()
    private let bgView = UIView()
    private let shadowView = UIView()
    
    var color: UIColor = AppColors.accent {
        didSet {
            bgView.backgroundColor = color
            shadowView.backgroundColor = color.withAlphaComponent(0.5)
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            // Can add a UIActivityIndicatorView here
            alpha = isLoading ? 0.7 : 1.0
            isUserInteractionEnabled = !isLoading
        }
    }
    
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
        
        shadowView.backgroundColor = color.withAlphaComponent(0.5)
        shadowView.layer.cornerRadius = 2
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shadowView)
        
        bgView.backgroundColor = color
        bgView.layer.cornerRadius = 2
        bgView.layer.borderWidth = 2
        // We'll set border color dynamically based on trait collection if needed, 
        // but for now let's leave it as dark for contrast or clear.
        bgView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        bgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bgView)
        
        titleLabel.font = AppFonts.pixel(size: 10)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        ])
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc private func touchDown() {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
            self.bgView.transform = CGAffineTransform(translationX: 2, y: 2)
            self.shadowView.transform = CGAffineTransform(translationX: -2, y: -2)
        }
        animator.startAnimation()
    }
    
    @objc private func touchUp() {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut) {
            self.bgView.transform = .identity
            self.shadowView.transform = .identity
        }
        animator.startAnimation()
    }
}
