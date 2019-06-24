//
//  ChatHeaderVIew.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 20/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

@IBDesignable
class ChatHeaderView: UIView {
    
    
    @IBInspectable var color1: UIColor = Colors().greenGradient1
    @IBInspectable var color2: UIColor = Colors().greenGradient2
    
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        drawWaveView()
    }
    
    
    private func drawWaveView() {
        
        let mainPath = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: bounds.height)
        let endPoint = CGPoint(x: bounds.width, y: bounds.height)
        
        mainPath.move(to: CGPoint(x: bounds.width, y: 0))
        mainPath.addLine(to: CGPoint(x: 0, y: 0))
        mainPath.addLine(to: startPoint)
        mainPath.addQuadCurve(to: endPoint, controlPoint: CGPoint(x: startPoint.x + bounds.width / 2,
                                                                  y: (startPoint.y + endPoint.y) / 2 + 30))
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
