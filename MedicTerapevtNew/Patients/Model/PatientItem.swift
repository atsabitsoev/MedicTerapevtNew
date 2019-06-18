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
    var imageUrl: URL
    
    
    init(id: String,
         name: String,
         conclusion: String,
         imageUrl: URL) {
        
        self.id = id
        self.name = name
        self.conclusion = conclusion
        self.imageUrl = imageUrl
    }
    
}
