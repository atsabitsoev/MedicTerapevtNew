//
//  ProfileService.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 31/07/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfileService {
    
    
    static let standard = ProfileService()
    private init() {}
    
    
    var profile: DoctorProfile?
    var errorGetProfile: String?
    
    var errorUpdateProfile: String?
    
    
    func getProfile() {
        
        let url = "\(ApiInfo().baseUrl)/therapist/\(TokenService.standard.id!)/profile"
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
                    
                    switch response.response?.statusCode {
                        
                    case 200:
                        
                        print(json)
                        let doctorProfileJSON = json["data"]["therapist"]
                        let name = doctorProfileJSON["name"].stringValue
                        let surname = doctorProfileJSON["surname"].stringValue
                        let position = doctorProfileJSON["therapistPosition"].stringValue
                        
                        let doctorProfile = DoctorProfile(name: name,
                                                          surname: surname,
                                                          position: position)
                        self.profile = doctorProfile
                        self.errorGetProfile = nil
                        
                    default:
                        
                        print(json)
                        let errorString = json["message"].stringValue
                        self.errorGetProfile = errorString
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    self.errorGetProfile = errorString
                    print(errorString)
                    
                }
                
                NotificationManager.post(.getDoctorProfileRequestAnswered)
        }
    }
    
    
    func updateProfile() {
        
        let url = "\(ApiInfo().baseUrl)/therapist/\(TokenService.standard.id!)/profile/update"
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        
        guard let profile = self.profile else { return }
        let parameters: Parameters = ["profile": ["name": profile.name,
                                                  "surname": profile.surname,
                                                  "therapistPosition": profile.position]]
        
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
                        
                        print(json)
                        self.errorUpdateProfile = nil
                        
                    default:
                        
                        print(json)
                        let errorString = json["message"].stringValue
                        self.errorUpdateProfile = errorString
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    self.errorUpdateProfile = errorString
                    print(errorString)
                    
                }
                
                NotificationManager.post(.updateDoctorProfileRequestAnswered)
        }
    }
    
    
}
