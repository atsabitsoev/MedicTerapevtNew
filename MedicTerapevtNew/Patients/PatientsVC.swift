//
//  PatientsVC.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 18/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class PatientsVC: UIViewController, UITabBarControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var patients: [PatientItem] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        self.tabBarController?.delegate = self
        
        addObservers()
        fetchPatients()
        tableView.reloadData()
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatePatientsList),
                                               name: NSNotification.Name(NotificationNames.getPatientsListRequestAnswered.rawValue),
                                               object: nil)
    }
    
    
    private func fetchPatients() {
        
        PatientsListService.standard.getListRequest()
    }
    
    @objc private func updatePatientsList() {
        
        guard PatientsListService.standard.errorGettingList == nil else {
            showErrorAlert(message: PatientsListService.standard.errorGettingList)
            return
        }
        
        self.patients = PatientsListService.standard.masPatients!
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    
    private func showErrorAlert(message: String?) {
        
        let alert = UIAlertController(title: "Ошибка", message: message ?? "Возникла неизвестная ошибка", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    private func setNavigationBar() {
        
        let colors = [Colors().greenGradient1,
                      Colors().greenGradient2]
        self.navigationController!.navigationBar.setGradientBackground(colors: colors, startPoint: .bottomLeft, endPoint: .topRight)
        self.tabBarController!.navigationItem.title = "Мои пациенты"
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.viewControllers![1] != viewController {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            setNavigationBar()
            print("fd")
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    

}
