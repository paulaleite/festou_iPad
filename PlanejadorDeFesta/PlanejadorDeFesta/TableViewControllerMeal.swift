//
//  TableViewControllerMeal.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit

class TableViewControllerMeal: UITableViewController {
    
    var selectedRow =  1
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        if selectedRow == 1{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.accessoryType = .none
        } else if selectedRow == 2{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.accessoryType = .none 
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
}
