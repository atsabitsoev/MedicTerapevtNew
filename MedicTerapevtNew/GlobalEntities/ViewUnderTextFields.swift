//
//  ViewUnderTextFields.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

@IBDesignable
class ViewUnderTextFields: UIView {
    
   
    @IBInspectable var mainColor: UIColor = UIColor.white
    @IBInspectable var isSmall: Bool = false
    var cornerRadius: CGFloat {
        if isSmall {
            return bounds.height / 2
        }
        return bounds.height / 3
    }
    
    @IBInspectable var myCornerRadius: CGFloat = -1
    @IBInspectable var shadowOpacity: Float = 0.15
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowRadius: CGFloat = 15
    var shadowOffset = CGSize(width: 0, height: 2)
    
    @IBInspectable var lineColor: UIColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    @IBInspectable var lineCount: Int = 0
    
    let shadowView = UIView()
    
    override func draw(_ rect: CGRect) {
        setupShadow()
        guard lineCount > 0 else { return }
        drawLines(lineCount)
    }
    
    
    func setupShadow() {
        shadowView.frame = frame
        if myCornerRadius < 0 {
            shadowView.layer.cornerRadius = cornerRadius
        } else {
            if myCornerRadius == 1000 {
                shadowView.layer.cornerRadius = bounds.height / 2
            } else {
                shadowView.layer.cornerRadius = myCornerRadius
            }
        }
        shadowView.layer.shadowOffset = shadowOffset
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.backgroundColor = mainColor
        superview!.insertSubview(shadowView, belowSubview: self)
    }
    
    private func drawLines(_ count: Int) {
        
        let linesInset = bounds.height / CGFloat(count + 1)
        
        for i in 1...count {
            let line = UIBezierPath()
            line.move(to: CGPoint(x: 0,
                                  y: CGFloat(i) * linesInset))
            line.addLine(to: CGPoint(x: bounds.width - cornerRadius / 2,
                                     y: CGFloat(i) * linesInset))
            line.lineWidth = 1
            lineColor.setStroke()
            line.stroke()
        }
    }

}
