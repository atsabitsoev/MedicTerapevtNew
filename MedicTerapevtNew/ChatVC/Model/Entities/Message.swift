//
//  Message.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 21/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


class Message {
    
    var text: String
    var sender: Sender
    var time: Date
    var contentType: MessageContentType
    var image: UIImage? {
        didSet {
            if image != nil {
                contentType = .photo
            }
        }
    }
    
    init(text: String,
         sender: Sender,
         time: Date,
         contentType: MessageContentType,
         image: UIImage? = nil) {
        
        self.text = text
        self.sender = sender
        self.time = time
        self.contentType = contentType
        self.image = image
        
    }
    
}
