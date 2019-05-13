//
//  TableViewControllerMeal.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MealTableViewController: UITableViewController {
    
    var selectedRow:Int = 1
    
    public var party:Party?
    
    public var partyTVC:MenuTableViewController?
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
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
    
    @IBAction func next (_ sender: Any) {
        var newDoesHaveMeal:Bool = false
        if selectedRow == 1 {
            newDoesHaveMeal = true
        }
        
        if let _ = partyTVC {
            if let context = context {
                //party = partyTVC!.parties.last!
                party!.doesHaveMeal = newDoesHaveMeal
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "partyTime")
        if let partyTime = controller as? TimeTableViewController {
            partyTime.party = party
            partyTime.partyTVC = partyTVC
        }
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
}
