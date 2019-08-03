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
    
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
    }
    var id: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "id")
        }
        get {
            return UserDefaults.standard.string(forKey: "id")
        }
    }
    
}
