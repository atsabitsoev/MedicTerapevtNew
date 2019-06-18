//
//  EnterService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class EnterService {
    
    
    private init() {}
    static let standard = EnterService()
    
    
    var errorString: String?
    
    
    func sendLoginRequest(login: String, password: String) {
        
        let url = "\(ApiInfo().baseUrl)/auth/signin"
        
        let parameters: Parameters = ["login": login,
                                      "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            
            do {
                
                switch response.response?.statusCode {
                    
                case 200:
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    
                    TokenService.standard.token = json["data"]["token"].stringValue
                    TokenService.standard.id = json["data"]["id"].stringValue
                    
                    NotificationManager.post(.enterRequestAnswered)
                    
                default:
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    
                    self.errorString = json["data"]["error"].stringValue
                    
                    NotificationManager.post(.enterRequestAnswered)
                    
                }
                
            } catch {
                
                self.errorString = error.localizedDescription
                
                NotificationManager.post(.enterRequestAnswered)
                
            }
        }
    }
    
    
}
