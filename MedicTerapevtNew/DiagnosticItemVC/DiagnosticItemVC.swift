//
//  DiagnosticItemVC.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 19/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class DiagnosticItemVC: UIViewController {
    
    
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    var imageLink: URL!
    private var image: UIImage = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        self.loadImage()
    }
    
    
    private func setNavigationBar() {
        
        let itemShare = UIBarButtonItem(image: UIImage(named: "Поделиться"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(shareTapped))
        itemShare.tintColor = #colorLiteral(red: 0.9725490196, green: 0.3803921569, blue: 0.3529411765, alpha: 1)
        itemShare.image = itemShare.image?.withRenderingMode(.alwaysTemplate)
        self.navigationItem.setRightBarButtonItems([itemShare], animated: false)
    }
    
    
    private func loadImage() {
        
        do {
            let dataImage = try Data(contentsOf: imageLink)
            let image = UIImage(data: dataImage)
            self.imageMain.image = image
            activityView.stopAnimating()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    @objc private func shareTapped() {
        
        let imageToShare = [imageMain.image!]
        let activityVC = UIActivityViewController(activityItems: imageToShare,
                                                  applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC,
                     animated: true,
                     completion: nil)
    }

}
