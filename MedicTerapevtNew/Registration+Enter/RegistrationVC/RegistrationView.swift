//
//  ViewController.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class RegistrationView: UIViewController {
    
    
    @IBOutlet var viewWaveBottomMas: [WaveGradientView]!
    @IBOutlet weak var viewUnderTextFields: ViewUnderTextFields!
    @IBOutlet weak var butGo: ButtonGradient!
    @IBOutlet weak var viewUnderButEnter: ViewUnderTextFields!
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewBackground: UIView!
    
    
    let registrationService = RegistrationService.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        addTapRecognizer()
        setTFDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        turnViewsUpsideDown(viewWaveBottomMas)
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(registrationRequestAnswered),
                                               name: NSNotification.Name(NotificationNames.registrationRequestAnswered.rawValue),
                                               object: nil)
    }
    
    private func addTapRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(backgroundTapped))
        viewBackground.addGestureRecognizer(recognizer)
    }
    
    @objc private func backgroundTapped() {
        
        self.view.endEditing(true)
    }
    
    
    private func turnViewsUpsideDown(_ views: [UIView]) {
        for view in views {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    
    private func setTFDelegates() {
        
        tfLogin.delegate = self
        tfPassword.delegate = self
        tfConfirmPassword.delegate = self
    }
    
    func pullUp() {
        
        let origin = CGPoint(x: view.frame.minX,
                             y: view.frame.minY - 100)
        let size = view.frame.size
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(origin: origin, size: size)
            self.view.layoutIfNeeded()
        }
    }
    
    func pullDown() {
        
        let origin = CGPoint(x: view.frame.minX,
                             y: view.frame.minY + 100)
        let size = view.frame.size
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRect(origin: origin, size: size)
            self.view.layoutIfNeeded()
        }
    }
    
    
    //MARK: Регистрация
    
    private func checkCredentialsAndMakeRegistrationRequest() {
        
        guard let login = tfLogin.text, let password = tfPassword.text else {
            showErrorAlert(message: "Заполните все поля")
            return
        }
        
        startLoadingAnimation()
        
        if trueCredentials() {
            registrationService.sendRegistrationRequest(login: login, password: password)
        } else {
            showErrorAlert(message: "Пароли не совпадают")
            stopLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        
        butGo.removeImage()
        activityIndicator.startAnimating()
        
    }
    
    private func stopLoadingAnimation() {
        
        butGo.setMyImage()
        activityIndicator.stopAnimating()
        
    }
    
    private func trueCredentials() -> Bool {
        
        guard tfPassword.text == tfConfirmPassword.text else { return false }
        return true
    }
    
    @objc private func registrationRequestAnswered() {
        stopLoadingAnimation()
        
        let success = registrationService.registrationRequestSucceed
        
        if success {
            performSegue(withIdentifier: "RegistrationToCode", sender: nil)
        } else {
            showErrorAlert(message: registrationService.errorRegistrationString)
        }
    }
    
    
    //MARK: Показать ошибку
    
    private func showErrorAlert(message: String?) {
        
        let alert = UIAlertController(title: "Ошибка", message: message ?? "Возникла неизвестная ошибка", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Анимации кнопок
    
    @IBAction func butEnterTouchDown(_ sender: UIButton) {
        animateButEnter(pressed: true)
    }
    
    @IBAction func butEnterTouchUpInside(_ sender: UIButton) {
        animateButEnter(pressed: false)
    }
    
    @IBAction func butEnterTouchUpOutside(_ sender: UIButton) {
        animateButEnter(pressed: false)
    }
    
    private func animateButEnter(pressed: Bool) {
        
        switch pressed {
        case true:
            
            UIView.animate(withDuration: 0.05) {
                self.viewUnderButEnter.shadowView.transform = CGAffineTransform(scaleX: 1, y: 0.9)
            }
            
        case false:
            
            UIView.animate(withDuration: 0.05) {
                self.viewUnderButEnter.shadowView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
    }
    
    
    @IBAction func butGoTouchDown(_ sender: UIButton) {
        animateButGo(pressed: true)
    }
    
    @IBAction func butGoTouchUpInside(_ sender: UIButton) {
        animateButGo(pressed: false)
        checkCredentialsAndMakeRegistrationRequest()
        self.view.endEditing(true)
    }
    
    @IBAction func butGoTouchUpOutside(_ sender: UIButton) {
        animateButGo(pressed: false)
    }
    
    private func animateButGo(pressed: Bool) {
        
        switch pressed {
        case true:
            
            UIView.animate(withDuration: 0.05) {
                self.butGo.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            
        case false:
            
            UIView.animate(withDuration: 0.05) {
                self.butGo.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegistrationToCode" {
            
            let codeVC = segue.destination as! RegistrationCodeVC
            codeVC.userLogin = tfLogin.text
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

}

