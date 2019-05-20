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
    
    var wrongAmountGuestsLabel:UILabel?
    
    var wrongAmountDrunkGuestsLabel:UILabel?
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
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
        
        wrongAmountGuestsLabel = setWrongLabel()
        wrongAmountDrunkGuestsLabel = setWrongLabel()
        
        nextButton.isEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        selectedSection = indexPath.section
        
        if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: indexPath)!.accessoryType == .none {
            tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType = .checkmark
            selected = true
            drunkGuestsTableViewCell.isHidden.toggle()
            if wrongAmountDrunkGuestsLabel?.superview == self.view {
                wrongAmountDrunkGuestsLabel?.isHidden.toggle()
            }
        } else if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            selected = false
            drunkGuestsTableViewCell.isHidden.toggle()
            if wrongAmountDrunkGuestsLabel?.superview == self.view {
                wrongAmountDrunkGuestsLabel?.isHidden.toggle()
            }
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
        
        if newNumGuests > 0, newNumGuests < 1000000,
            (newDoesDrink && newNumDrunkGuests > 0 && newNumDrunkGuests <= newNumGuests) || !newDoesDrink {
            if let _ = partyTVC {
                if let context = context {
                    
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
    
    @IBAction func guestsTextFieldDidChange(_ sender: Any) {
        if let textField = amountOfGuestsTextField {
            if let text = textField.text, let num = Int64(text) {
                if num < 1 {
                    addWrongLabel(label: wrongAmountGuestsLabel!, text: "O número de convidados deve ser maior ou igual a 1")
                    if wrongAmountDrunkGuestsLabel?.superview == self.view {
                        wrongAmountDrunkGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else if num > 1000000 || textField.text!.count > 7 {
                    addWrongLabel(label: wrongAmountGuestsLabel!, text: "O número de convidados deve ser menor que 1000000")
                    if wrongAmountDrunkGuestsLabel?.superview == self.view {
                        wrongAmountDrunkGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else if let text = amountOfDrunkGuestsTextField.text, let numOfDrunkGuests = Int64(text), num < numOfDrunkGuests{
                    addWrongLabel(label: wrongAmountGuestsLabel!, text: "O número de convidados que bebem não pode ser maior que o número de convidados")
                    if wrongAmountDrunkGuestsLabel?.superview == self.view {
                        wrongAmountDrunkGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else {
                    wrongAmountGuestsLabel!.removeFromSuperview()
                    if let hidden = wrongAmountDrunkGuestsLabel?.isHidden {
                        if hidden {
                            wrongAmountDrunkGuestsLabel?.isHidden = false
                        } else {
                            nextButton.isEnabled = true
                        }
                    }
                }
            } else {
                addWrongLabel(label: wrongAmountGuestsLabel!, text: "Número inválido")
                if wrongAmountDrunkGuestsLabel?.superview == self.view {
                    wrongAmountDrunkGuestsLabel?.isHidden = true
                }
                nextButton.isEnabled = false
            }
        }
    }

    @IBAction func drunkGuestsTextFieldDidChange(_ sender: Any) {
        if let textField = amountOfDrunkGuestsTextField {
            if let text = textField.text, let num = Int64(text) {
                if num < 1 && selected {
                    addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: "O número de convidados que bebem deve ser maior ou igual a 1")
                    if wrongAmountGuestsLabel?.superview == self.view {
                        wrongAmountGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else if let text = amountOfGuestsTextField.text, let numOfGuests = Int64(text), num > numOfGuests || textField.text!.count > 7 {
                    addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: "O número de convidados que bebem não pode ser maior que o número de convidados")
                    if wrongAmountGuestsLabel?.superview == self.view {
                        wrongAmountGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else {
                    wrongAmountDrunkGuestsLabel!.removeFromSuperview()
                    if let hidden = wrongAmountGuestsLabel?.isHidden {
                        if hidden {
                            wrongAmountGuestsLabel?.isHidden = false
                        }
                        else {
                            nextButton.isEnabled = true
                        }
                    }
                }
            } else {
                addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: "Número inválido")
                if wrongAmountGuestsLabel?.superview == self.view {
                    wrongAmountGuestsLabel?.isHidden = true
                }
                nextButton.isEnabled = false
            }
        }
    }
    
    
//    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
//    }
    
//    @objc func textFieldDidEndEditing(_ textField: UITextField) {
//    }
    
    func setWrongLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.textColor = UIColor.red
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.cornerRadius = 10
        
        return label
    }
    
    func addWrongLabel(label: UILabel, text: String) {
        self.view.addSubview(label)
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y - 380
        label.text = text
    }
}


