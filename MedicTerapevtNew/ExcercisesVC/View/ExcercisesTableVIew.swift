//
//  ExcercisesTableVIew.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 17/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


extension ExcercisesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "excercisesCell") as! ExercisesCell
        
        cell.labTitle.text = currentExercises[indexPath.row].name
        
        let imageUrl = currentExercises[indexPath.row].preview
        let imageData = try! Data(contentsOf: imageUrl)
        cell.imagePreview.image = UIImage(data: imageData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoURL = currentExercises[indexPath.row].video
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        let cell = tableView.cellForRow(at: indexPath) as! ExercisesCell
        
        UIView.animate(withDuration: 0.05) {
            cell.viewShadow.shadowView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell.viewPlay.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell.imagePreview.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ExercisesCell
        
        UIView.animate(withDuration: 0.05) {
            cell.viewShadow.shadowView.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.viewPlay.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.imagePreview.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
}
