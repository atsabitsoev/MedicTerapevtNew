//
//  GetExercisesService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 04/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class GetExercisesService {
    
    private init() {}
    static let standard = GetExercisesService()
    
    
    var allExercises: [Exercise]?
    var errorAllExcercises: String?
    
    var currentExercises: [Exercise]?
    var errorGetPatientExcercises: String?
    
    var addExerciseError: String?
    var removeExerciseError: String?
    
    
    func sendGetAllExercisesRequest() {
        
        let url = "\(ApiInfo().baseUrl)/exercise"
        print("token - \(TokenService.standard.token!)")
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
     
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers, interceptor: nil)
            .responseJSON { (response) in
            
                do {
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    print(json)
                    
                    switch response.response?.statusCode {
                        
                    case 200:
                        
                        let exercisesJSON = json["data"]["exercises"].arrayValue
                        print(exercisesJSON)
                        
                        let exercises = self.parseExercises(json: exercisesJSON)
                        
                        self.allExercises = exercises
                        self.errorAllExcercises = nil
                        
                    default:
                        
                        self.errorAllExcercises = json["data"]["error"].stringValue
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    print(errorString)
                    self.errorAllExcercises = errorString
                }
                
                NotificationManager.post(.getAllExercisesRequestAnswered)
        }
    }
    
    
    func sendGetPatientExercisesRequest(id: String) {
        
        
        let url = "\(ApiInfo().baseUrl)/patient/\(id)/exercise"
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: nil)
            .responseJSON { (resposne) in
                
                do {
                    
                    let responseValue = try resposne.result.get()
                    let json = JSON(responseValue)
                    print(json)
                    
                    switch resposne.response?.statusCode {
                        
                    case 200:
                        
                        let exercisesJSON = json["data"]["exercises"].arrayValue
                        let exercises = self.parseExercises(json: exercisesJSON)
                        
                        self.currentExercises = exercises
                        self.errorGetPatientExcercises = nil
                        
                    default:
                        
                         self.errorAllExcercises = json["data"]["error"].stringValue
                        
                    }
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    print(errorString)
                    self.errorGetPatientExcercises = errorString
                }
                
                NotificationManager.post(.getCurrentPatientExercisesRequestAnswered)
        }
    }
    
    
    func addExercise(patientId: String, exerciseId: String) {
        
        let url = "\(ApiInfo().baseUrl)/patient/\(patientId)/exercise/\(exerciseId)/append"
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        
        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: nil)
            .responseJSON { (response) in
                
                do {
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    print(json)
                        
                    self.addExerciseError = json["data"]["result"].boolValue ? nil : json["message"].string
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    print(errorString)
                    self.addExerciseError = errorString
                }
                
                NotificationManager.post(.addExerciseRequestAnswered)
        }
    }
    
    
    func removeExercise(patientId: String, exerciseId: String) {
        
        let url = "\(ApiInfo().baseUrl)/patient/\(patientId)/exercise/\(exerciseId)/remove"
        let headers: HTTPHeaders = ["Cookie": "token=\(TokenService.standard.token!); id=\(TokenService.standard.id!)"]
        
        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: nil)
            .responseJSON { (response) in
                
                do {
                    
                    let responseValue = try response.result.get()
                    let json = JSON(responseValue)
                    print(json)
                    
                    self.removeExerciseError = json["data"]["result"].boolValue ? nil : json["message"].string
                    
                } catch {
                    
                    let errorString = error.localizedDescription
                    print(errorString)
                    self.removeExerciseError = errorString
                }
                
                NotificationManager.post(.removeExerciseRequestAnswered)
        }
    }
    
    
    private func parseExercises(json: [JSON]) -> [Exercise] {
        
        return json.map({ (json) -> Exercise in
            print("gdsf")
            let previewString = json["videos"].arrayValue[0]["preview"].stringValue
            let videoString = json["videos"].arrayValue[0]["video"].stringValue
            
            let previewUrl = URL(string: "\(ApiInfo().baseUrl)\(previewString)")!
            let videoUrl = URL(string: "\(ApiInfo().baseUrl)\(videoString)")!
            let name = json["name"].stringValue
            
            let id = json["id"].stringValue
            
            return Exercise(name: name, preview: previewUrl, video: videoUrl, id: id)
        })
    }
    
}
