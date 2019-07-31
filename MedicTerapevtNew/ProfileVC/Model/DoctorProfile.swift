//
//  DoctorProfile.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 31/07/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation


class DoctorProfile {
    
    init(name: String,
         surname: String,
         position: String) {
        
        self.name = name
        self.surname = surname
        self.position = position
    }
    
    var name: String
    var surname: String
    var position: String
}
