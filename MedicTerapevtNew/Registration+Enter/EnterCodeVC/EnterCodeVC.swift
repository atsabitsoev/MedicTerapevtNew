//
//  EnterCodeVC.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 05/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class EnterCodeVC: UIViewController {
    
    
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var viewUnderTfCode: SimpleGradientView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewShadowButSend: ViewUnderTextFields!
    @IBOutlet weak var butSend: ButtonGradient!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var constWhiteViewCenter: NSLayoutConstraint!
    @IBOutlet weak var viewAlert: UIView!
    
    
    let forgotPassService = ForgotPasswordService.standard
    
    
    var tfCodeShown = false
    var login: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addTapToExit()
        setTFDelegates()
        configureView()
        addObservers()
    }
    
    
    private func addTapToExit() {
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(backgroundTapped))
        viewBackground.addGestureRecognizer(recognizer)
    }
    
    @objc private func backgroundTapped() {
        self.dismiss(animated: true,
                     completion: nil)
    }
    
    
    private func setTFDelegates() {
        
        tfLogin.delegate = self
        tfCode.delegate = self
    }
    
    
    private func configureView() {
        
        tfCode.isHidden = true
        viewUnderTfCode.isHidden = true
        labTitle.text = "Введите логин"
        tfLogin.isSecureTextEntry = false
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sendCodeRequestAnswered),
                                               name: NSNotification.Name(NotificationNames.sendCodeForgotPasswordRequestAnswered.rawValue),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newPasswordRequestAnswered),
                                               name: NSNotification.Name(NotificationNames.confirmForgotPasswordRequestAnswered.rawValue),
                                               object: nil)
    }
    
    @objc private func sendCodeRequestAnswered() {
        
        stopAnimationLoading()
        
        guard forgotPassService.sendCodeToUserError == nil else {
            showErrorAlert(forgotPassService.sendCodeToUserError!)
            return
        }
        
        showTfCode()
    }
    
    @objc private func newPasswordRequestAnswered() {
        
        stopAnimationLoading()
        
        guard forgotPassService.confirmationError == nil else {
            showErrorAlert(forgotPassService.confirmationError!)
            return
        }
        
        showSucceessAlert()
    }
    
    
    private func showErrorAlert(_ message: String) {
        
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    private func showSucceessAlert() {
        
        let alert = UIAlertController(title: "Успех!",
                                      message: "Пароль успешно изменен",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) { (action) in
            alert.dismiss(animated: true,
                          completion: nil)
            self.dismiss(animated: true,
                         completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    
    private func showTfCode() {
        
        tfCode.isHidden = false
        viewUnderTfCode.isHidden = false
        labTitle.text = "Введите новый пароль и код подтверждения"
        tfLogin.placeholder = "Новый пароль"
        tfLogin.isSecureTextEntry = true
        tfLogin.text = ""
        
        tfCodeShown = true
    }
    
    
    private func startAnimationLoading() {
        
        activityIndicator.startAnimating()
    }
    
    private func stopAnimationLoading() {
        
        activityIndicator.stopAnimating()
    }
    
    
    func pullUp() {
        
        let offset: CGFloat = -120
        
        self.constWhiteViewCenter.constant += offset
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
            self.viewShadowButSend.setupShadow()
        }
    }
    
    func pullDown() {
        
        let offset: CGFloat = 120
        
        self.constWhiteViewCenter.constant += offset
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
            self.viewShadowButSend.setupShadow()
        }
    }
    
    
    private func sendCodeToUserRequest(_ login: String) {
        
        forgotPassService.sendCodeToUserRequest(login: login)
    }
    
    private func newPasswordRequest(login: String, newPass: String, code: String) {
        
        forgotPassService.confirmRequest(login: login, newPassword: newPass, code: code)
    }
    
    
    @IBAction func butSendTouchUpInside(_ sender: UIButton) {
        
        switch tfCodeShown {
            
        case false:
            
            guard let login = tfLogin.text else { return }
            
            self.login = login
            sendCodeToUserRequest(login)
            startAnimationLoading()
            
        case true:
            
            guard let newPassword = tfLogin.text else { return }
            guard let code = tfCode.text else { return }
            
            newPasswordRequest(login: self.login!, newPass: newPassword, code: code)
            startAnimationLoading()
            
        }
    }
    

}
