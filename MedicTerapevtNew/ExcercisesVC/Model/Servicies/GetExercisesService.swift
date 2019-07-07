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
                        
                        let exercises = exercisesJSON.map({ (json) -> Exercise in
                            print("gdsf")
                            let previewString = json["videos"].arrayValue[0]["preview"].stringValue
                            let videoString = json["videos"].arrayValue[0]["video"].stringValue
                            
                            let previewUrl = URL(string: "\(ApiInfo().baseUrl)\(previewString)")!
                            let videoUrl = URL(string: "\(ApiInfo().baseUrl)\(videoString)")!
                            let name = json["name"].stringValue
                            
                            return Exercise(name: name, preview: previewUrl, video: videoUrl)
                        })
                        
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
    
}
