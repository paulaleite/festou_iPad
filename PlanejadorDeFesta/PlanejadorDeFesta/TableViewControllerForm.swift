//
//  TableViewControllerForm.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit

class TableViewControllerForm: UITableViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //self.view.addGestureRecognizer(tap)
        
        //amountOfDrunkPeopleTextField.delegate = self
        //amountOfPeopleTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

//    @objc func dismissKeyboard() {
//        self.view.endEditing(true)
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 3 {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "partyInitial")
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
    }
}
