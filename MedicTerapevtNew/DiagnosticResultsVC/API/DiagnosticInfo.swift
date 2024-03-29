//
//  DiagnosticInfo.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 18/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation


class DiagnosticInfo {
    
    var backbone: [URL]
    var otherInfo: [OtherDiagnosticInfo]
    var conclusion: String
    var date: Date
    var id: String
    
    init (backbone: [URL],
          otherInfo: [OtherDiagnosticInfo],
          conclusion: String,
          date: Date,
          id: String) {
        
        self.backbone = backbone
        self.otherInfo = otherInfo
        self.conclusion = conclusion
        self.date = date
        self.id = id
    }
    
}


class OtherDiagnosticInfo {
    
    var name: String
    var imageUrl: URL
    
    init(name: String,
         imageUrl: URL) {
        
        self.name = name
        self.imageUrl = imageUrl
    }
}
