//
//  SimpleGradientView.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 20/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


@IBDesignable
class SimpleGradientView: UIView {
    
    
    @IBInspectable var color1: UIColor = Colors().greenGradient1
    @IBInspectable var color2: UIColor = Colors().greenGradient2
    
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        addGradient(to: path)
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
