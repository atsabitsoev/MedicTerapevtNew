//
//  PatientItem.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 18/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation


class PatientItem {
    
    var id: String
    var name: String
    var conclusion: String
    var dialogId: String
    
    
    init(id: String,
         name: String,
         conclusion: String,
         dialogId: String) {
        
        self.id = id
        self.name = name
        self.conclusion = conclusion
        self.dialogId = dialogId
    }
    
}
