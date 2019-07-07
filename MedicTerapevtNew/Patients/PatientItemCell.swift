//
//  PatientItemCell.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 18/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

import UIKit

class PatientItemCell: UITableViewCell {
    
    
    @IBOutlet weak var imagePatient: UIImageView!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labDescribtion: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
        imagePatient.layer.cornerRadius = imagePatient.bounds.height / 2
    }
    
    
    override func awakeFromNib() {
        imagePatient.layer.cornerRadius = imagePatient.bounds.height / 2
    }
    
    
}
