//
//  EnterCodeTFDelegate.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 05/06/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


extension EnterCodeVC: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pullUp()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.pullDown()
    }
}
