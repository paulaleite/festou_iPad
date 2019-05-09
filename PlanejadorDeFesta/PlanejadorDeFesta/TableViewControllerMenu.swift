//
//  TableViewControllerMenu.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit

class TableViewControllerMenu: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "partyMainTasks")
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
    }
    
}
