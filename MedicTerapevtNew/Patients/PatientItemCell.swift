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
    
    
    let messageExistColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    let messageNotExistColor: UIColor = .clear
    
    
    @IBOutlet weak var imagePatient: UIImageView!
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labDescribtion: UILabel!
    @IBOutlet weak var viewDarkRound: ViewUnderTextFields!
    @IBOutlet weak var labMessageCount: UILabel!
    
    var unreadMessages = 0 {
        didSet {
            if unreadMessages == 0 {
                labMessageCount.isHidden = true
                viewDarkRound.mainColor = messageNotExistColor
            } else {
                labMessageCount.isHidden = false
                viewDarkRound.mainColor = messageExistColor
                labMessageCount.text = "\(unreadMessages)"
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    
    
    
    override func awakeFromNib() {
        

    }
    
    
}
