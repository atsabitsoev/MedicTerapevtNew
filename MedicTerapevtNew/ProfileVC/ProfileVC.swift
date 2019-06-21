//
//  ProfileVC.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 21/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITabBarControllerDelegate {
    

    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        image?.round()
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.viewControllers![1] != viewController {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            print("fd")
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    

}
