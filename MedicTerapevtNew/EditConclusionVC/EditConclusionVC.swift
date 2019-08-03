//
//  EditConclusionVC.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 03/08/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class EditConclusionVC: UIViewController {
    
    
    @IBOutlet weak var textViewMain: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var conclusion: String?
    var patientId: String?
    var infoId: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setOldConclusion()
        addObservers()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saved),
            name: NSNotification.Name(rawValue: NotificationNames.changeConclusionRequestAnswered.rawValue),
            object: nil)
    }
    
    
    private func setOldConclusion() {
        
        self.textViewMain.text = conclusion
    }
    
    
    @objc private func saved() {
        
        self.activityIndicator.stopAnimating()
        
        guard ChangeConclusionService.standard.errorChangeConclusion == nil else {
            let errorString = ChangeConclusionService.standard.errorChangeConclusion!
            showErrorAlert(errorString)
            return
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    private func showErrorAlert(_ message: String) {
        
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок",
                                     style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    

    @IBAction func SaveButTapped(_ sender: UIBarButtonItem) {
        
        activityIndicator.startAnimating()
        
        guard let patientId = self.patientId,
            let conclusion = textViewMain.text,
            let infoId = self.infoId else {
                return
        }
        ChangeConclusionService.standard.sendChangeRequest(patientId: patientId, infoId: infoId, conclusion: conclusion)
    }
}
