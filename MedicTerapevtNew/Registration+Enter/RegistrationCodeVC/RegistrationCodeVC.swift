//
//  TypeCodeVC.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class RegistrationCodeVC: UIViewController {
    
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewAlert: UIView!
    
    
    let registrationService = RegistrationService.standard
    
    
    var userLogin: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        tfCode.delegate = self
        configureBackground()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(confirmationRequestAnswered),
                                               name: NSNotification.Name(NotificationNames.confirmationRequestAnswered.rawValue),
                                               object: nil)
    }
    
    
    private func sendConfirmRequest(login: String, code: String) {
        
        RegistrationService.standard.confirmLogin(login: login, code: code)
        
        startLoadingAnimation()
    }
    
    @objc private func confirmationRequestAnswered() {
        
        let success = registrationService.confirmationCodeSucceed
        
        if success {
            alertSuccess()
        } else {
            tfCode.text = ""
        }
        
        stopLoadingAnimation()
    }
    
    private func alertSuccess() {
        
        let alert = UIAlertController(title: "Успех!", message: "Вы успешно зарегистрированы!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            timer.invalidate()
            alert.dismiss(animated: true, completion: nil)
            self.goToEnterVC()
        }
    }
    
    private func goToEnterVC() {
        
        let enterVC = UIStoryboard(name: "Registration+Enter", bundle: nil).instantiateViewController(withIdentifier: "EnterVC")
        self.present(enterVC, animated: true, completion: nil)
    }
    
    
    private func configureBackground() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        viewBackground.addGestureRecognizer(recognizer)
    }
    
    
    func pullUp() {
        
        let offset: CGFloat = 120
        UIView.animate(withDuration: 0.3) {
            self.viewAlert.frame.origin.y -= offset
        }
    }
    
    func pullDown() {
        
        let offset: CGFloat = 120
        UIView.animate(withDuration: 0.3) {
            self.viewAlert.frame.origin.y += offset
        }
    }
    
    
    private func startLoadingAnimation() {
        
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    private func stopLoadingAnimation() {
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    
    @objc private func backgroundTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tfCodeTextChanged(_ sender: UITextField) {
        
        guard let code = sender.text, code.count == 5 else { return }
        
        sendConfirmRequest(login: userLogin!, code: code)
        self.view.endEditing(true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}
