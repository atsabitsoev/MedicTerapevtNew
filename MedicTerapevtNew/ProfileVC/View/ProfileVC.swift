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
        
        ProfileService.standard.getProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillLayoutSubviews() {
        image?.round()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}
