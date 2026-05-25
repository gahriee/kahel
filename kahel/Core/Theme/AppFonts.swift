import UIKit

enum AppFonts {
    static func pixel(size: CGFloat) -> UIFont {
        // Fallback to Courier/Monospaced if custom font isn't loaded yet
        return UIFont(name: "PressStart2P-Regular", size: size) ?? UIFont.monospacedSystemFont(ofSize: size, weight: .regular)
    }
    
    static func body(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        // Inter-VariableFont maps to "Inter" normally, depending on how it's embedded
        // If not found, fallback to systemFont
        let fontName: String
        switch weight {
        case .bold, .heavy, .black:
            fontName = "Inter-Bold"
        case .medium, .semibold:
            fontName = "Inter-Medium"
        default:
            fontName = "Inter-Regular"
        }
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
}
