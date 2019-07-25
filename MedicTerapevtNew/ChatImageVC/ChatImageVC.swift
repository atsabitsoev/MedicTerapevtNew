//
//  ChatImageVC.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 22/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class ChatImageVC: UIViewController {
    
    
    @IBOutlet weak var imageViewMain: UIImageView!
    
    
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewMain.image = image
    }
    
    
    @IBAction func butCloseTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true,
                     completion: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}
