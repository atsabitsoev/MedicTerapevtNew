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
        
    }
    
    override func viewWillLayoutSubviews() {
        image?.round()
    }
    

}
