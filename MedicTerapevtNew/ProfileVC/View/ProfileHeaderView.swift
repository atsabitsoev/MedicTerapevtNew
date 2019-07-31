

import UIKit

@IBDesignable
class ProfileHeaderView: UIView {
    
    
    @IBInspectable var color1: UIColor = Colors().greenGradient1
    @IBInspectable var color2: UIColor = Colors().greenGradient2
    
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        drawWaveView()
    }
    
    
    private func drawWaveView() {
        
        let mainPath = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: bounds.height)
        let endPoint = CGPoint(x: bounds.width, y: bounds.height / 1.6)
        
        mainPath.move(to: CGPoint(x: bounds.width, y: 0))
        mainPath.addLine(to: CGPoint(x: 0, y: 0))
        mainPath.addLine(to: startPoint)
        mainPath.addCurve(to: endPoint,
                          controlPoint1: CGPoint(x: startPoint.x + bounds.width / 10,
                                                 y: startPoint.y - bounds.height / 1.8),
                          controlPoint2: CGPoint(x: endPoint.x - bounds.width / 3,
                                                 y: endPoint.y + bounds.height / 2.5))
        mainPath.close()
        
        addGradient(to: mainPath)
    }
    
    private func addGradient(to path: UIBezierPath) {
        
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor,
                           color2.cgColor]
        gradient.frame = path.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        
        layer.addSublayer(gradient)
    }
    
}
