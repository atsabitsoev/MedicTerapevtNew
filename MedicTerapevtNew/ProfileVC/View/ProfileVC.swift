//
//  ProfileVC.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 21/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITabBarControllerDelegate {
    
    
    private let profileService = ProfileService.standard

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tfPosition: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfSurname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        addRecognizer()
        profileService.getProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillLayoutSubviews() {
        image?.round()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(profileGot),
                                               name: NSNotification.Name(NotificationNames.getDoctorProfileRequestAnswered.rawValue),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(profileUpdated),
                                               name: NSNotification.Name(NotificationNames.updateDoctorProfileRequestAnswered.rawValue),
                                               object: nil)
    }
    
    
    private func addRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func profileGot() {
        
        guard let profile = profileService.profile else {
            let errorString = profileService.errorGetProfile!
            showError(errorString)
            return
        }
        
        tfName.text = profile.name
        tfSurname.text = profile.surname
        tfPosition.text = profile.position
    }
    
    @objc private func profileUpdated() {
        
        guard profileService.errorUpdateProfile == nil else {
            
            let errorString = profileService.errorUpdateProfile!
            showError(errorString)
            return
        }
        
        showSuccessAlert()
    }
    
    
    private func showError(_ message: String) {
        
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    private func showSuccessAlert() {
        
        let alert = UIAlertController(title: "Сохранено",
                                      message: nil,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    
    @IBAction func butSaveTapped(_ sender: UIButton) {
        
        profileService.profile?.name = tfName.text ?? ""
        profileService.profile?.surname = tfSurname.text ?? ""
        profileService.profile?.position = tfPosition.text ?? "masseur"
        profileService.updateProfile()
    }
    
    
    @IBAction func butLogOutTapped(_ sender: UIButton) {
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}
