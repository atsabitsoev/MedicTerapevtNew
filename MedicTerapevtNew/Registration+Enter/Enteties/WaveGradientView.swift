//
//  WaveGradientView.swift
//  WaveGradientView
//
//  Created by Ацамаз Бицоев on 29/04/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

@IBDesignable
class WaveGradientView: UIView {
    
    
    @IBInspectable var color1: UIColor = #colorLiteral(red: 0.368627451, green: 0.2078431373, blue: 0.6941176471, alpha: 1)
    @IBInspectable var color2: UIColor = #colorLiteral(red: 0.003921568627, green: 0.6745098039, blue: 0.7568627451, alpha: 1)
    

    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        drawWaveView()
    }
    
    
    private func drawWaveView() {
        
        let mainPath = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: bounds.height)
        let endPoint = CGPoint(x: bounds.width, y: 0)
        
        mainPath.move(to: CGPoint(x: bounds.width, y: 0))
        mainPath.addLine(to: CGPoint(x: 0, y: 0))
        mainPath.addLine(to: startPoint)
        mainPath.addCurve(to: endPoint,
                          controlPoint1: CGPoint(x: startPoint.x + 0.2 * bounds.width,
                                                 y: (startPoint.y + endPoint.y) / 2 - 80),
                          controlPoint2: CGPoint(x: endPoint.x - 0.135 * bounds.width,
                                                 y: (startPoint.y + endPoint.y) / 2 + 30))
        mainPath.close()
        
        addGradient(to: mainPath)
    }
    
    private func addGradient(to path: UIBezierPath) {
        
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor,
                           color2.cgColor]
        gradient.frame = path.bounds
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask
        
        layer.addSublayer(gradient)
    }
 

}
