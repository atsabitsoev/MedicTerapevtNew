//
//  DiagnosticConclusionCell.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 20/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class DiagnosticConclusionCell: UITableViewCell {
    
    
    @IBOutlet weak var labDate: UILabel!
    @IBOutlet weak var labConclusion: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
