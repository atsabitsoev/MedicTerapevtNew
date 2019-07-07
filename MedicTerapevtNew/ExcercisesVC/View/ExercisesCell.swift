//
//  ExcercisesCell.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 17/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class ExercisesCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var viewPlay: ViewPlay!
    @IBOutlet weak var viewShadow: ViewUnderTextFields!
    
    
    override func layoutSubviews() {
        
        configureImagePreview()
        
    }
    
    
    private func configureImagePreview() {
        
        imagePreview.layer.cornerRadius = 12
        imagePreview.clipsToBounds = true
        
    }

}
