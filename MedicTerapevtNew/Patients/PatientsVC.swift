//
//  PatientsVC.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 18/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit

class PatientsVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var patients: [PatientItem] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        fetchPatients()
        tableView.reloadData()
    }
    
    
    private func fetchPatients() {
        
        patients = [PatientItem(name: "Геннадий Иванович",
                                conclusion: "Шизофрения самой последней стадии",
                                imageUrl: URL(string: "http://apple.com")!),
                    PatientItem(name: "Андрей петрович",
                                conclusion: "Абсолютно здоров",
                                imageUrl: URL(string: "http://apple.com")!)]
    }
    
    
    private func setNavigationBar() {
        
        let colors = [Colors().greenGradient1,
                      Colors().greenGradient2]
        self.tabBarController!.navigationController!.navigationBar.setGradientBackground(colors: colors, startPoint: .bottomLeft, endPoint: .topRight)
        let item = UINavigationItem(title: "Мои пациенты")
        self.tabBarController?.navigationController?.navigationBar.setItems([item], animated: true)
    }
    

}
