//
//  ViewRoundedBorders.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 24/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


@IBDesignable
class ViewRoundedBorders: UIView {
    
    @IBInspectable var borderColor: UIColor = Colors().greenMain
    @IBInspectable var cornerRadius: CGFloat = -1
    
    override var layer: CALayer {
        
        super.layer.borderWidth = 1
        super.layer.borderColor = borderColor.cgColor
        
        if cornerRadius == -1 {
            super.layer.cornerRadius = bounds.height / 2
        } else {
            super.layer.cornerRadius = cornerRadius
        }
        return super.layer
    }
    
}
