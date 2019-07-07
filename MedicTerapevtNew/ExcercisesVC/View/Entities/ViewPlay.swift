//
//  ViewPlay.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 17/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

@IBDesignable
class ViewPlay: UIView {
    
    
    @IBInspectable var color: UIColor = Colors().greenMain

    
    override func draw(_ rect: CGRect) {
        
        drawGreenCircle()
        drawTriangle()
        
    }
    
    
    private func drawGreenCircle() {
        
        let circle = UIBezierPath(ovalIn: bounds)
        color.setFill()
        circle.fill()
        
    }
    
    private func drawTriangle() {
        
        let path = UIBezierPath()
        let insetX = bounds.width/20
        
        let firstPoint = CGPoint(x: bounds.width / 3 + insetX, y: bounds.height / 4)
        let secondPoint = CGPoint(x: bounds.width / 3 + insetX, y: bounds.height / 4 * 3)
        let thirdPoint = CGPoint(x: bounds.width / 3 * 2 + insetX, y: bounds.height / 2)
        
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.close()
        UIColor.white.setFill()
        path.fill()
        
    }
    

}
