//
//  TokenService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation


class TokenService {
    
    private init() {}
    static let standard = TokenService()
    
    var token: String?
    var id: String?
    
}
