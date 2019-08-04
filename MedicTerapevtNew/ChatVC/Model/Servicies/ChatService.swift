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
    
    init() {
        print("создал")
        startConnection()
    }
    static var standard: ChatService?
    static func destroy() {
        self.standard = nil
    }
    
    
    private var connected = false
    
    var lastMessage: Message? {
        didSet {
            NotificationManager.post(.newMessage)
        }
    }
    var unReadMessages: [String: Int] = [:]
    
    
    func startConnection() {
        
        socket = manager.defaultSocket
        
        addHandlers()
        socket.connect()
    }
    
    
    private let manager = SocketManager(socketURL: URL(string: ApiInfo().baseUrl)!,
                                        config: [.secure(false),
                                                 .path("/socstream"),
                                                 .log(false)])
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
            
            let dialogIds = dialogsArr.map({ (json) -> String in
                return json["id"].stringValue
            })
            print("dialog id - \(dialogIds)")
        }
        
        socket.on("enteredDialog") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            let messagesJSON = json["messages"].arrayValue
            let messages = self.parseMessagesFromJSON(messagesJSON: messagesJSON)
            
            MessageHistoryService.standard.messages = messages.reversed()
            NotificationManager.post(.messagesFetched)
        }
        
        socket.on("messageReceive") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            let messageJSON = json["message"]
            
            guard messageJSON["author"].stringValue != TokenService.standard.id! else { return }
            
            let contentTypeString = messageJSON["type"].string
            var contentType: MessageContentType = .text
            var messageText = ""
            var image: UIImage?
            
            switch contentTypeString {
            case MessageContentType.text.rawValue:
                
                messageText = messageJSON["message"].stringValue
                
            case MessageContentType.photo.rawValue:
                
                let imageUrl = messageJSON["message"].stringValue
                guard let imageData = try? Data(contentsOf: URL(string: "\(ApiInfo().baseUrl)\(imageUrl)")!) else { return }
                image = UIImage(data: imageData)
                contentType = .photo
                
            case MessageContentType.video.rawValue:
                
                let text = messageJSON["message"].stringValue
                let videoUrl = "\(ApiInfo().baseUrl)\(text)"
                messageText = videoUrl
                contentType = .video
                
            default:
                
                print("error")
                
            }
            
            self.lastMessage = Message(text: messageText, sender: .penPal, time: Date(), contentType: contentType, image: image)
        }
        
        socket.on("leavedDialog") { (data, ack) in
            
            print("Покинул чат")
        }
        
        socket.on("newMessage") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            self.unReadMessages[json["message"]["author"].stringValue] = self.unReadMessages[json["message"]["author"].stringValue] != nil ? self.unReadMessages[json["message"]["author"].stringValue]! + 1 : 1
            
            NotificationManager.post(.newUnreadMessage)
        }
        
        socket.on("messageListReceive") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
            
            if json["messages"].arrayValue.count >= 30 {
                let jsonMessages = json["messages"].arrayValue
                let receivedMessages = self.parseMessagesFromJSON(messagesJSON: jsonMessages)
                MessageHistoryService.standard.messages = receivedMessages.reversed() + MessageHistoryService.standard.messages
            }
            
            NotificationManager.post(.messagesFetched)
        }
        
        socket.on("error-pipe") { (data, ack) in
            
            let json = JSON(data[0])
            print(json)
        }
        
        
    }
    
    
    private func parseMessagesFromJSON(messagesJSON: [JSON]) -> [Message] {
        
        let messages = messagesJSON.map({ (json) -> Message in
            
            var image: UIImage?
            if let url = URL(string: "\(ApiInfo().baseUrl)\(json["message"])"),
                let imageData = try? Data(contentsOf: url) {
                
                image = UIImage(data: imageData)
            }
            
            let message = Message(text: json["message"].string ?? "",
                                  sender: json["author"].stringValue == TokenService.standard.id! ? .user : .penPal,
                                  time: Date(timeIntervalSince1970: json["date"].doubleValue / 1000),
                                  contentType: MessageContentType(rawValue: json["type"].stringValue) ?? .text,
                                  image: image)
            return message
        })
        
        return messages
    }
    
    
    func sendMessage(_ message: Message) {
        
        var messageText = ""
        var type = ""
        
        switch message.contentType {
            
        case .text:
            
            messageText = message.text
            type = "text"
            
        case .photo:
            
            let image = message.image
            let imageData = image?.jpegData(compressionQuality: 0.5)
            let imageBase64 = imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            print(imageBase64)
            messageText = "data:image/jpg;base64,\(imageBase64)"
            type = "photo"
            
        case .video:
            
            guard let videoUrl = URL(string: message.text) else { return }
            guard let videoData = try? Data(contentsOf: videoUrl) else { return }
            let videoBase64 = videoData.base64EncodedString(options: .lineLength64Characters)
            messageText = "data:video/mp4;base64,\(videoBase64)"
            print(videoBase64)
            type = "video"
            
        }
        
        socket.emit("message", ["message": messageText,
                                "type": type]) {
                                    print("отправлено")
        }
        
        print(["message": message.text])
    }
    
    
    func loadMoreMessages() {
        
        socket.emit("getMessageList", ["skip": MessageHistoryService.standard.messages.count,
                                       "limit": 30])
    }
    
    
    func enterChat(dialogId: String) {
        
        self.socket.emit("enterInDialog", ["dialogId" : dialogId],
                         completion: {
                            
                            print("enterInDialogEmited")
        })
    }
    
    
    func exitFromChat() {
        
        socket.emit("exitFromChat" , []) {
            print("Попытка выйти из чата")
        }
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
        ChatService.destroy()
    }

}
