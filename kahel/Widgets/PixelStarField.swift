import UIKit

class PixelStarField: UIView {
    
    private var displayLink: CADisplayLink?
    private var stars: [Star] = []
    private var t: Double = 0
    
    struct Star {
        var x: Double
        var y: Double
        var size: Double
        var speed: Double
        var opacity: Double
        
        static func random() -> Star {
            return Star(
                x: Double.random(in: 0...1),
                y: Double.random(in: 0...1),
                size: Double.random(in: 0...1) * 2.5 + 0.5,
                speed: Double.random(in: 0...1) * 0.04 + 0.005,
                opacity: Double.random(in: 0...1) * 0.6 + 0.2
            )
        }
    }
    
    init(starCount: Int = 60) {
        super.init(frame: .zero)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        stars = (0..<starCount).map { _ in Star.random() }
        
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    @objc private func step(displaylink: CADisplayLink) {
        t += displaylink.targetTimestamp - displaylink.timestamp
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = rect.size
        
        for s in stars {
            let dy = fmod(s.y + t * s.speed, 1.0)
            let flicker = 0.6 + 0.4 * sin(t * 10 + s.x * 30)
            
            let alpha = CGFloat(s.opacity * flicker)
            // Color #7c3aed
            context.setFillColor(UIColor(hex: 0x7c3aed).withAlphaComponent(alpha).cgColor)
            
            let starRect = CGRect(
                x: s.x * size.width,
                y: dy * size.height,
                width: s.size,
                height: s.size
            )
            context.fill(starRect)
        }
    }
}
