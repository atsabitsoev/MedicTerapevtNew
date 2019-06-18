//
//  NotificationManager.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 22/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation


class NotificationManager {
    
    
    static func post(_ notifName: NotificationNames) {
        
        NotificationCenter.default.post(name: NSNotification.Name(notifName.rawValue), object: nil)
    }
    
    
}
