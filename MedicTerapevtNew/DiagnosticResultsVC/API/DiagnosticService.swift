//
//  DiagnosticService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 13/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class DiagnosticService {
    
    
    private init() {}
    static let standard = DiagnosticService()
    
    
    var errorGetInfo: String?
    var masDiagnosticInfo: [DiagnosticInfo]?
    
    
    func getDiagnosticInfoRequest() {
        
        let url = "\(ApiInfo().baseUrl)/patient/\(TokenService.standard.id!)/diagnosticInfo"
        
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
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
                        
                        let resultsArr = json["data"]["info"].arrayValue
                        
                        var masDiagnosticInfo: [DiagnosticInfo] = []
                        
                        for result in resultsArr {
                            
                            var otherArr: [OtherDiagnosticInfo] = []
                            
                            let otherArrJSON = result["other"].arrayValue
                            
                            for otherInfoJSON in otherArrJSON {
                                
                                let name = otherInfoJSON["name"].stringValue
                                let imageUrlString = otherInfoJSON["image"].stringValue
                                let imageUrl = URL(string: "\(ApiInfo().baseUrl)\(imageUrlString)")!
                                let otherInfo = OtherDiagnosticInfo(name: name, imageUrl: imageUrl)
                                otherArr.append(otherInfo)
                            }
                            
                            let backboneArrJSON = result["backbone"].arrayValue
                            let backboneArr = backboneArrJSON.map({ (backboneLinkJSON) -> URL in
                                let backboneOneURL = URL(string: "\(ApiInfo().baseUrl)\(backboneLinkJSON.stringValue)")!
                                return backboneOneURL
                            })
                            
                            let conclusion = result["conclusion"].stringValue
                            let dateInt = result["created"].doubleValue
                            let date = Date(timeIntervalSince1970: dateInt / 1000)
                            
                            let diagnosticInfo = DiagnosticInfo(backbone: backboneArr,
                                                                otherInfo: otherArr,
                                                                conclusion: conclusion,
                                                                date: date)
                            masDiagnosticInfo.append(diagnosticInfo)
                        }
                        
                        self.masDiagnosticInfo = masDiagnosticInfo
                        
                        
                    default:
                        
                        let errorString = json["data"]["error"].stringValue
                        self.errorGetInfo = errorString
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    self.errorGetInfo = errorString
                    print(errorString)
                    
                }
                
                NotificationManager.post(.getDiagnosticInfoRequestAnswered)
        }
    }
}
