//
//  TableViewController.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GuestsTableViewController: UITableViewController, UITextFieldDelegate {
    
    public var party:Party?
    
    public var partyTVC:MenuTableViewController?
    
    var context:NSManagedObjectContext?
    
    @IBOutlet weak var amountOfGuestsTextField: UITextField!
    
    @IBOutlet weak var amountOfDrunkGuestsTextField: UITextField!
    
    @IBOutlet weak var drunkGuestsTableViewCell: UITableViewCell!
    
    var selected:Bool = true
    
    var selectedRow:Int = 0
    
    var selectedSection:Int = 2
    
    var goingForwards:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        amountOfDrunkGuestsTextField.delegate = self
        amountOfGuestsTextField.delegate = self
        tableView.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        selectedSection = indexPath.section
        
        if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: indexPath)!.accessoryType == .none {
            tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType = .checkmark
            selected = true
            drunkGuestsTableViewCell.isHidden.toggle()
        } else if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            selected = false
            drunkGuestsTableViewCell.isHidden.toggle()
        }
    }
    
    @IBAction func next(_ sender: Any) {
    
        goingForwards = true
        
        var newNumGuests:Int = 0
        var newDoesDrink:Bool = false
        var newNumDrunkGuests:Int = 0
        
        if amountOfGuestsTextField.text != nil,
            amountOfGuestsTextField.text!.count > 0,
            let num = Int(amountOfGuestsTextField.text!) {
            newNumGuests = num
        }
        
        if selected {
            newDoesDrink = true
            if amountOfDrunkGuestsTextField.text != nil,
                amountOfDrunkGuestsTextField.text!.count > 0,
                let num = Int(amountOfDrunkGuestsTextField.text!) {
                newNumDrunkGuests = num
            }
        }
        
        if newNumGuests != 0,
            (newDoesDrink && newNumDrunkGuests != 0) || !newDoesDrink {
            if let _ = partyTVC {
                if let context = context {
                    party = Party(context: context)
                    party?.numOfGuests = Int32(newNumGuests)
                    party?.doesDrink = newDoesDrink
                    party?.numOfDrunkGuests = Int32(newNumDrunkGuests)
                }
            }
            
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "partyMeal")
            if let partyMeal = controller as? MealTableViewController {
                partyMeal.party = party
                partyMeal.partyTVC = partyTVC
                partyMeal.guestsTVC = self
            }
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !goingForwards {
            context?.delete(party!)
            
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
