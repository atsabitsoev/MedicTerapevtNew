//
//  MessageHistoryService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 22/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


class MessageHistoryService {
    
    
    private init() {}
    static let standard = MessageHistoryService()
    
    
    var messages: [Message] = []
}
