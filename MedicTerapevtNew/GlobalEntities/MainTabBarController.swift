//
//  MainTabBarController.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 22/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    


    override func viewDidLoad(){
        super.viewDidLoad()

        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatClosed), name: NSNotification.Name("chatClosed"), object: nil)

    }
    
    
    @objc private func chatClosed() {
        
        selectedIndex = 0
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: OpeningChatVC.self) {
            let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            let chatVC = chatStoryboard.instantiateViewController(withIdentifier: "ChatVC")
            self.present(chatVC, animated: true, completion: nil)
        }
        return true
    }
}
