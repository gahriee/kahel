import UIKit

class PixelTextField: UIView {
    
    let textField = UITextField()
    private let titleLabel = UILabel()
    private let bgView = UIView()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title.uppercased()
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
        titleLabel.font = AppFonts.pixel(size: 7)
        titleLabel.textColor = AppColors.textDim(for: traitCollection)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        bgView.backgroundColor = AppColors.surfaceAlt(for: traitCollection)
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = AppColors.border(for: traitCollection).cgColor
        bgView.layer.cornerRadius = 2
        bgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bgView)
        
        textField.font = AppFonts.body(size: 14, weight: .medium)
        textField.textColor = AppColors.text(for: traitCollection)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        bgView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 14),
            textField.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -14),
            textField.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func editingDidBegin() {
        bgView.layer.borderColor = AppColors.accent.cgColor
        titleLabel.textColor = AppColors.accent
    }
    
    @objc private func editingDidEnd() {
        bgView.layer.borderColor = AppColors.border(for: traitCollection).cgColor
        titleLabel.textColor = AppColors.textDim(for: traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !textField.isEditing {
            bgView.layer.borderColor = AppColors.border(for: traitCollection).cgColor
            titleLabel.textColor = AppColors.textDim(for: traitCollection)
        }
        bgView.backgroundColor = AppColors.surfaceAlt(for: traitCollection)
        textField.textColor = AppColors.text(for: traitCollection)
    }
}
