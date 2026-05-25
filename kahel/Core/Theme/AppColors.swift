import UIKit

enum AppColors {
    // Shared
    static let accent = UIColor(hex: 0xff6600)   // The Kahel orange
    static let gold = UIColor(hex: 0xffb800)     // For XP/Gold
    static let danger = UIColor(hex: 0xff4444)   // Red for errors/debt
    static let success = UIColor(hex: 0x00c853)  // Green for success

    // Dark palette (Night mode)
    static let bgDark = UIColor(hex: 0x140f0a)
    static let surfaceDark = UIColor(hex: 0x21170f)
    static let surfaceAltDark = UIColor(hex: 0x2c1d11)
    static let borderDark = UIColor(hex: 0x3d2b1f)
    static let textDark = UIColor(hex: 0xffeedd)
    static let textDimDark = UIColor(hex: 0x8b7355)
    static let textMutedDark = UIColor(hex: 0x6e5c47)

    // Light palette (Day mode)
    static let bgLight = UIColor(hex: 0xfdf8f5)
    static let surfaceLight = UIColor(hex: 0xffffff)
    static let surfaceAltLight = UIColor(hex: 0xf5eee9)
    static let borderLight = UIColor(hex: 0xe6d5c3)
    static let textLight = UIColor(hex: 0x2c1d11)
    static let textDimLight = UIColor(hex: 0x8b7355)
    static let textMutedLight = UIColor(hex: 0xa6937c)

    // Adaptive Colors based on UITraitCollection
    static func bg(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? bgDark : bgLight
    }
    
    static func surface(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? surfaceDark : surfaceLight
    }
    
    static func surfaceAlt(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? surfaceAltDark : surfaceAltLight
    }
    
    static func border(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? borderDark : borderLight
    }
    
    static func text(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? textDark : textLight
    }
    
    static func textDim(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? textDimDark : textDimLight
    }
    
    static func textMuted(for traitCollection: UITraitCollection) -> UIColor {
        return traitCollection.userInterfaceStyle == .dark ? textMutedDark : textMutedLight
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
