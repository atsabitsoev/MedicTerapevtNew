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
    
    var patientID: String!
    var masDiagnosticInfo: [DiagnosticInfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        tableView.delaysContentTouches = false
        navigationController?.navigationBar.shadowImage = UIImage()

        addObservers()
        
        DiagnosticService.standard.getDiagnosticInfoRequest(id: patientID)
        activityIndicator.startAnimating()
    }
    
    
    private func setNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(closeNav))
    }
    
    @objc private func closeNav() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
