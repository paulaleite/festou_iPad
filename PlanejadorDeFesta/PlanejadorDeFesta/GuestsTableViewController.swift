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
    
    var selectedRow:Bool = false
    
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
            selectedRow = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedRow = true
        }

    }
    
    @IBAction func nextButton(_ sender: Any) {
        var newNumGuests:Int = 1
        var newDoesDrink:Bool = false
        var newNumDrunkGuests:Int = 0
        
        if amountOfGuestsTextField.text != nil,
            amountOfGuestsTextField.text!.count > 0,
            let num = Int(amountOfGuestsTextField.text!) {
            newNumGuests = num
        }
        
        if selectedRow {
            newDoesDrink = true
            if amountOfDrunkGuestsTextField.text!.count > 0,
                let num = Int(amountOfDrunkGuestsTextField.text!) {
                newNumDrunkGuests = num
            }
        }
        
        if let _ = party {
            party!.numOfGuests = Int16(newNumGuests)
            party!.doesDrink = newDoesDrink
            party!.numOfDrunkGuests = Int16(newNumDrunkGuests)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            if let partyTVC = partyTVC {
                if let context = context {
                    let newParty = NSEntityDescription.insertNewObject(forEntityName: "Party", into: context) as! Party
                    party?.numOfGuests = Int16(newNumGuests)
                    party?.doesDrink = newDoesDrink
                    party?.numOfDrunkGuests = Int16(newNumDrunkGuests)
                    partyTVC.parties.append(newParty)
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
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
