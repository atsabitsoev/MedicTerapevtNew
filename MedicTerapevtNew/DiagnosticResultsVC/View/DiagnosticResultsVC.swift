//
//  DiagnosticResultsVC.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 17/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class DiagnosticResultsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let diagnosticService = DiagnosticService.standard
    
    
    var masDiagnosticInfo: [DiagnosticInfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delaysContentTouches = false
        navigationController?.navigationBar.shadowImage = UIImage()

        addObservers()
        
        DiagnosticService.standard.getDiagnosticInfoRequest()
        activityIndicator.startAnimating()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getInfoAnswered),
                                               name: NSNotification.Name(NotificationNames.getDiagnosticInfoRequestAnswered.rawValue),
                                               object: nil)
    }
    
    
    @objc private func getInfoAnswered() {
        
        activityIndicator.stopAnimating()
        
        guard diagnosticService.errorGetInfo == nil else {
            
            showErrorAlert(message: diagnosticService.errorGetInfo)
            return
        }
        
        self.masDiagnosticInfo = diagnosticService.masDiagnosticInfo!
        tableView.reloadData()
    }
    
    
    private func showErrorAlert(message: String?) {
        
        let alert = UIAlertController(title: "Ошибка", message: message ?? "Возникла неизвестная ошибка", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
