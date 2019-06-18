//
//  PatientsTableview.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 18/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


extension PatientsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientItemCell") as! PatientItemCell
        
        let currentItem = patients[indexPath.row]
        cell.labName.text = currentItem.name
        cell.labDescribtion.text = currentItem.conclusion
        let imageData = try? Data(contentsOf: currentItem.imageUrl)
        cell.imagePatient.image = UIImage(data: imageData ?? Data())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
}
