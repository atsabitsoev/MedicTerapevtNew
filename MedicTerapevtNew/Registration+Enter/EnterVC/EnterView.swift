//
//  ViewController.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 03/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class EnterView: UIViewController {
    
    
    @IBOutlet var viewWaveBottomMas: [WaveGradientView]!
    @IBOutlet weak var viewUnderTextFields: ViewUnderTextFields!
    @IBOutlet weak var butGo: ButtonGradient!
    @IBOutlet weak var viewUnderButRegistration: ViewUnderTextFields!
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewBackground: UIView!
    
    
    let enterService = EnterService.standard
    
    
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
                                               selector: #selector(checkEnter),
                                               name: NSNotification.Name(rawValue: NotificationNames.enterRequestAnswered.rawValue),
                                               object: nil)
    }
    
    @objc private func checkEnter() {
        
        stopLoadingAnimation()
        
        guard TokenService.standard.token != nil else {
            showErrorAlert(message: enterService.errorString)
            return
        }
        
        openApp()
    }
    
    
    private func addTapRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(backgroundTapped))
        viewBackground.addGestureRecognizer(recognizer)
    }
    
    @objc private func backgroundTapped() {
        
        self.view.endEditing(true)
    }
    
    
    private func openApp() {
        
        let storyboard = UIStoryboard(name: "Registration+Enter", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String?) {
        
        let alert = UIAlertController(title: "Ошибка", message: message ?? "Возникла неизвестная ошибка", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func sendEnterRequest() {
        
        guard var login = tfLogin.text, let password = tfPassword.text else {
            showErrorAlert(message: "Заполните все поля")
            return
        }
        
        if hasOnlyNumbers(string: login) {
            if login.first! == "8" || login.first! == "7" {
                login.removeFirst()
                login = "+7\(login)"
            }
        }
        
        enterService.sendLoginRequest(login: login, password: password)
        startLoadingAnimation()
        
    }
    
    private func hasOnlyNumbers(string: String) -> Bool {
        
        let numbers = ["0","1","2","3","4","5","6","7","8","9"]
        for c in string {
            if !numbers.contains("\(c)") {
                return false
            }
        }
        return true
    }
    
    
    private func setTFDelegates() {
        
        tfLogin.delegate = self
        tfPassword.delegate = self
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
    
    
    private func startLoadingAnimation() {
        
        butGo.removeImage()
        activityIndicator.startAnimating()
        
    }
    
    private func stopLoadingAnimation() {
        
        butGo.setMyImage()
        activityIndicator.stopAnimating()
        
    }
    
    
    private func turnViewsUpsideDown(_ views: [UIView]) {
        for view in views {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    
    private func checkEditing() {
        
        if tfLogin.isEditing || tfPassword.isEditing {
            self.view.endEditing(true)
        }
    }
    
    
    @IBAction func butForgotTapped(_ sender: UIButton) {
        
        checkEditing()
        performSegue(withIdentifier: "EnterToCode", sender: nil)
    }
    
    
    //MARK: Анимации кнопок
    
    @IBAction func butRegistrationTouchDown(_ sender: UIButton) {
        animateButRegistration(pressed: true)
    }
    
    @IBAction func butRegistrationTouchUpInside(_ sender: UIButton) {
        animateButRegistration(pressed: false)
    }
    
    @IBAction func butRegistrationTouchUpOutside(_ sender: UIButton) {
        animateButRegistration(pressed: false)
    }
    
    private func animateButRegistration(pressed: Bool) {
        
        switch pressed {
        case true:
            
            UIView.animate(withDuration: 0.05) {
                self.viewUnderButRegistration.shadowView.transform = CGAffineTransform(scaleX: 1, y: 0.9)
            }
            
        case false:
            
            UIView.animate(withDuration: 0.05) {
                self.viewUnderButRegistration.shadowView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        }
    }
    
    
    @IBAction func butGoTouchDown(_ sender: UIButton) {
        animateButGo(pressed: true)
    }
    
    @IBAction func butGoTouchUpInside(_ sender: UIButton) {
        animateButGo(pressed: false)
        sendEnterRequest()
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
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

