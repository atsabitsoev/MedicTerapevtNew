//
//  ChatService.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 22/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class ChatService {
    
    private init() {
        print("создал")
        startConnection()
    }
    static let standard = ChatService()
    
    
    private var connected = false
    
    var lastMessage: Message? {
        didSet {
            NotificationManager.post(.newMessage)
        }
    }
    
    
    func startConnection() {
        
        socket = manager.defaultSocket
        
        addHandlers()
        socket.connect()
    }
    
    
    private let manager = SocketManager(socketURL: URL(string: ApiInfo().baseUrl)!,
                                        config: [.secure(false),
                                                 .path("/socstream"),
                                                 .log(true)])
    private var socket: SocketIOClient!
    private var name: String?
    private var resetAck: SocketAckEmitter?
    
    
    private func addHandlers() {
        
        
        socket.on(clientEvent: .connect) { data, ack in
            
            self.connected = true
            print("connect")
            
            
            self.socket.emit("auth",
                             ["userId" : "\(TokenService.standard.id!)", "token" : "\(TokenService.standard.token!)"],
                             completion: {
                                
                                print("authEmited")
            })
            
        }
        
        socket.on("authOk") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            let dialogsArr = json["dialogs"].arrayValue
            
            guard dialogsArr.count != 0 else {
                print("Нет доступных диалогов")
                return
            }
            
            let dialogId = dialogsArr.first!["id"].stringValue
            print("dialog id - \(dialogId)")
            
            self.socket.emit("enterInDialog", ["dialogId" : dialogId],
                             completion: {
                
                print("enterInDialogEmited")
            })
        }
        
        socket.on("enteredDialog") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            let messagesJSON = json["messages"].arrayValue
            let messages = messagesJSON.map({ (json) -> Message in
                let message = Message(text: json["message"].string ?? "",
                                      sender: json["author"].stringValue == TokenService.standard.id! ? .user : .penPal,
                                      time: Date(timeIntervalSince1970: json["date"].doubleValue / 1000),
                                      contentType: .text)
                return message
            })
            
            MessageHistoryService.standard.messages = messages
            NotificationManager.post(.messagesFetched)
        }
        
        socket.on("messageReceive") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            let messageJSON = json["message"]
            
            guard messageJSON["author"].stringValue != TokenService.standard.id! else { return }
            print("сооьщение из вне")
            let messageText = messageJSON["message"].stringValue
            
            self.lastMessage = Message(text: messageText, sender: .penPal, time: Date(), contentType: .text)
        }
        
        socket.on("leavedDialog") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
        }
        
        socket.on("newMessage") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
        }
        
        socket.on("messageListReceive") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
        }
        
        socket.on("error-pipe") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
        }
        
        
    }
    
    
    func sendMessage(_ message: Message) {
        
        socket.emit("message", ["message": message.text]) {
            print("отправлено")
        }
        
        print(["message": message.text])
    }
    
    
    func stopConnection() {
        
        socket.disconnect()
        socket.off(clientEvent: .connect)
        socket.off("authOk")
        socket.off("enteredDialog")
        socket.off("messageReceive")
        socket.off("leavedDialog")
        socket.off("newMessage")
        socket.off("messageListReceive")
        socket.off("newMessage")
        socket.off("error-pipe")
    }

}
