//
//  ChatTableviewDelegate.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 21/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messageArr[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        
        switch (message.sender, message.contentType) {
            
        case (.user, .text):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell") as! UserMessageCell
            cell.labText.text = message.text
            cell.labTime.text = formatter.string(from: message.time)
            return cell
            
        case (.penPal, .text):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PenPalMessageCell") as! PenPalMessageCell
            cell.labText.text = message.text
            cell.labTime.text = formatter.string(from: message.time)
            return cell
            
        case (.user, .photo):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserImageCell") as! UserImageCell
            let image = messageArr[indexPath.row].image
            cell.imageMain.image = image
            cell.set(image: image ?? UIImage())
            cell.labTime.text = formatter.string(from: message.time)
            return cell
            
        case (.penPal, .photo):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PenPalImageCell") as! PenPalImageCell
            let image = messageArr[indexPath.row].image
            cell.imageMain.image = image
            cell.set(image: image!)
            cell.labTime.text = formatter.string(from: message.time)
            return cell
            
        case (.user, .video):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserVideoCell")!
            return cell
            
        case (.penPal, .video):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PenPalVideoCell")!
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if messageArr[indexPath.row].contentType == .photo {
            
            let messagePhoto = messageArr[indexPath.row]
            let image = messagePhoto.image
            let chatImageVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatImageVC") as! ChatImageVC
            chatImageVC.image = image
            self.present(chatImageVC, animated: true, completion: nil)
        }
        
        if messageArr[indexPath.row].contentType == .video {
            
            let messageVideo = messageArr[indexPath.row]
            guard var videoUrl: URL = URL(string: "\(messageVideo.text)") else { return }
            if !messageVideo.text.hasPrefix("file") {
                if !"\(videoUrl)".hasPrefix("http") {
                    videoUrl = URL(string: "\(ApiInfo().baseUrl)\(messageVideo.text)")!
                } else {
                    videoUrl = URL(string: "\(messageVideo.text)")!
                }
                
            }
            
            print(videoUrl)
            let player = AVPlayer(url: videoUrl)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            self.present(playerVC,
                         animated: true,
                         completion: nil)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 && !allMessagesGot {
            ChatService.standard!.loadMoreMessages()
        }
    }
    
    
}
