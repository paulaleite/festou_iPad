//
//  TableViewController.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit

class TableViewControllerGuests: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountOfGuestsTextField: UITextField!
    
    @IBOutlet weak var amountOfDrunkGuestsTextField: UITextField!
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        amountOfDrunkGuestsTextField.delegate = self
        amountOfGuestsTextField.delegate = self
        tableView.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
