//
//  ViewController.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 08/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

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

}
