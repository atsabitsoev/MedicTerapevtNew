//
//  UserImageCell.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 21/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class UserImageCell: UITableViewCell {
    
    
    @IBOutlet weak var constrImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constrImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageMain: UIImageView! {
        didSet {
            imageMain.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var labTime: UILabel!
    
    
    func set(image: UIImage) {
        let maxSideSize: CGFloat = 250
        if max(image.size.width, image.size.height) <= maxSideSize {
            
            constrImageWidth.constant = image.size.width
            constrImageHeight.constant = image.size.height
        } else {
            
            let isWidthBigger = image.size.width > image.size.height ? true : false
            let multiplier = isWidthBigger ? image.size.height / image.size.width : image.size.width / image.size.height
            if isWidthBigger {
                
                constrImageWidth.constant = maxSideSize
                constrImageHeight.constant = maxSideSize * multiplier
            } else {
                
                constrImageHeight.constant = maxSideSize
                constrImageWidth.constant = maxSideSize * multiplier
                print("ширина - \(constrImageWidth)")
            }
        }
        
    }

}
