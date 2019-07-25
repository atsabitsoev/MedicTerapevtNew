//
//  AddDeleteButton.swift
//  MedicTerapevtNew
//
//  Created by Ацамаз Бицоев on 26/07/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit


enum AddDeleteButtonState {
    case delete
    case add
}


class AddDeleteButton: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self,
                  action: #selector(tapAction),
                  for: .touchUpInside)
    }

    
    var aDButtonState: AddDeleteButtonState = .delete {
        didSet {
            let deleteIconName = "Удалить иконка"
            let addIconName = "Добавить иконка"
            let currentIconName = aDButtonState == .delete ? deleteIconName : addIconName
            setImage(UIImage(named: currentIconName),
                     for: .normal)
        }
    }
    
    var addAction: () -> () = {}
    var deleteAction: () -> () = {}
    
    
    @objc
    private func tapAction() {
        switch aDButtonState {
        case .add:
            addAction()
        case .delete:
            deleteAction()
        }
    }

}
