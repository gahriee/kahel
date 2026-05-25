import UIKit

class ScanlineOverlay: UIView {
    
    var scanlineOpacity: CGFloat = 0.04 {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Scanlines
        context.setStrokeColor(UIColor.black.withAlphaComponent(scanlineOpacity).cgColor)
        context.setLineWidth(1)
        
        var y: CGFloat = 0
        while y < rect.height {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
            y += 3
        }
        context.strokePath()
        
        // Vignette
        let colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.45).cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0, 1])!
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height) * 1.3 / 2
        
        context.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: radius,
            options: .drawsAfterEndLocation
        )
    }
}
