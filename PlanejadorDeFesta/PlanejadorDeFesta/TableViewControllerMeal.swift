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
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
}
