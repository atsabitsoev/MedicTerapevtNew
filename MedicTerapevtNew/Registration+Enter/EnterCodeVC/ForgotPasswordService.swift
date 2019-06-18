//
//  ForgotPasswordService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 05/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ForgotPasswordService {
    
    
    private init() {}
    static let standard = ForgotPasswordService()
    
    
    var sendCodeToUserError: String?
    var confirmationError: String?
    
    
    func sendCodeToUserRequest(login: String) {
        
        let url = "\(ApiInfo().baseUrl)/auth/password/reset/request"
        
        let parameters: Parameters = ["login": login]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil)
            .responseJSON { (response) in
                
                do {
                    
                    let responseResult = try response.result.get()
                    let json = JSON(responseResult)
                    print(json)
                    
                    switch response.response?.statusCode {
                        
                    case 200:
                        
                        self.sendCodeToUserError = nil
                        
                    default:
                        
                        self.sendCodeToUserError = json["data"]["error"].stringValue
                    }
                    
                } catch {
                    
                    print(error.localizedDescription)
                    self.sendCodeToUserError = error.localizedDescription
                    
                }
                
                NotificationManager.post(.sendCodeForgotPasswordRequestAnswered)
        }
    }
    
    
    func confirmRequest(login: String, newPassword: String, code: String) {
        
        let url = "\(ApiInfo().baseUrl)/auth/password/reset/receive"
        
        let parameters: Parameters = ["login": login,
                                      "password": newPassword,
                                      "token": code]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil)
            .responseJSON { (response) in
                
                do {
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    print(json)
                    
                    switch response.response?.statusCode {
                        
                    case 200:
                        
                        self.confirmationError = nil
                        
                    default:
                        
                       self.confirmationError = json["data"]["error"].stringValue
                    }
                    
                } catch {
                    
                    print(error.localizedDescription)
                    self.confirmationError = error.localizedDescription
                }
                
                NotificationManager.post(.confirmForgotPasswordRequestAnswered)
        }
    }
    
}
