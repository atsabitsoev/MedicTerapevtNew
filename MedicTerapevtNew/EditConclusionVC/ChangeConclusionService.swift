//
//  ChangeConclusionService.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 03/08/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ChangeConclusionService {
    
    
    private init() {}
    static let standard = ChangeConclusionService()
    
    
    var errorChangeConclusion: String?
    
    
    func sendChangeRequest(patientId: String, infoId: String, conclusion: String) {
        
        let url = "\(ApiInfo().baseUrl)/patient/\(patientId)/diagnosticInfo/\(infoId)/changeConclusion"
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        let parameters: Parameters = ["conclusion": conclusion]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: nil)
            .responseJSON { (response) in
            
                do {
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    print(json)
                    
                    switch response.response?.statusCode {
                        
                    case 200:
                        
                        self.errorChangeConclusion = nil
                        
                    default:
                        
                        let errorString = json["message"].stringValue
                        self.errorChangeConclusion = errorString
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    self.errorChangeConclusion = errorString
                    
                }
                
                NotificationManager.post(.changeConclusionRequestAnswered)
        }
    }
}
