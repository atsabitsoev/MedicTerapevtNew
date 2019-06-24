//
//  PatientsListService.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 24/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class PatientsListService {
    
    
    static let standard = PatientsListService()
    private init() {}
    
    
    var errorGettingList: String?
    var masPatients: [PatientItem]?
    
    
    func getListRequest() {
        
        let url = "\(ApiInfo().baseUrl)/therapist/\(TokenService.standard.id!)/patient?skip=0&limit=10"
        
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: nil)
            .responseJSON { (response) in
                
                do {
                    
                    let json = try JSON(response.result.get())
                    print(json)
                    
                    switch response.response?.statusCode {
                        
                    case 200:
                        
                        let patientsJSON = json["data"]["patients"].arrayValue
                        let patients = patientsJSON.map({ (json) -> PatientItem in
                            
                            let id = json["id"].stringValue
                            let name = json["name"].stringValue
                            let surname = json["surname"].stringValue
                            let conclusion = json["conclusion"].stringValue
                            
                            let patient = PatientItem(id: id, name: "\(name) \(surname)", conclusion: conclusion)
                            return patient
                        })
                        self.masPatients = patients
                        self.errorGettingList = nil
                        
                    default:
                        
                        let errorString = "ошибка получения списка пациентов"
                        print(errorString)
                        self.errorGettingList = errorString
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    print(errorString)
                    self.errorGettingList = errorString
                    
                }
                
                NotificationManager.post(.getPatientsListRequestAnswered)
        }
    }
}
