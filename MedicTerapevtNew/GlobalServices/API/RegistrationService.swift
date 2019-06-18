//
//  RegistrationService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RegistrationService {
    
    
    private init() {}
    static let standard = RegistrationService()
    
    
    var errorRegistrationString: String?
    var registrationRequestSucceed = false
    var errorConfirmationString: String?
    var confirmationCodeSucceed = false
    
    
    func sendRegistrationRequest(login: String, password: String) {
        
        let url = "\(ApiInfo().baseUrl)/auth/signup"
        
        let parameters: Parameters = ["login": login,
                                      "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            
            do {
                
                let responseValue = try response.result.get()
                let json = JSON(responseValue)
                print(json)
                
                switch response.response?.statusCode {
                    
                case 200:
                    
                    self.registrationRequestSucceed = true
                    
                default:
                    
                    self.registrationRequestSucceed = false
                    self.errorRegistrationString = json["data"]["error"].stringValue
                    
                }
                
            } catch {
                
                print(error.localizedDescription)
                self.errorRegistrationString = error.localizedDescription
                self.registrationRequestSucceed = false
            }
            
            NotificationManager.post(.registrationRequestAnswered)
        }
    }
    
    
    func confirmLogin(login: String, code: String) {
        
        let url = "\(ApiInfo().baseUrl)/auth/signup/confirm"
        
        let parameters: Parameters = ["login": login,
                                      "code": code]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { (response) in
            
            do {
                
                let responseValue = try response.result.get()
                let json = JSON(responseValue)
                print(json)
                
                switch response.response?.statusCode {
                    
                case 200:
                    
                    self.confirmationCodeSucceed = true
                    
                default:
                    
                    self.confirmationCodeSucceed = false
                    self.errorConfirmationString = json["data"]["error"].stringValue
                    
                }
                
            } catch {
                
                print(error.localizedDescription)
                self.errorConfirmationString = error.localizedDescription
                self.confirmationCodeSucceed = false
            }
            
            NotificationManager.post(.confirmationRequestAnswered)
        }
    }
    
}
