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
    
    let red = UIColor(red: 214/255, green: 59/255, blue: 87/255, alpha: 1)
    
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
        amountOfDrunkGuestsTextField.addTarget(self, action: #selector(drunkGuestsTextFieldDidChange(_:)), for: .editingChanged)
        amountOfGuestsTextField.delegate = self
        amountOfGuestsTextField.addTarget(self, action: #selector(guestsTextFieldDidChange(_:)), for: .editingChanged)
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
                wrongAmountDrunkGuestsLabel?.isHidden = false
                nextButton.isEnabled.toggle()
            }
        } else if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            selected = false
            drunkGuestsTableViewCell.isHidden.toggle()
            if wrongAmountDrunkGuestsLabel?.superview == self.view {
                wrongAmountDrunkGuestsLabel?.isHidden = true
                nextButton.isEnabled.toggle()
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
                    addWrongLabel(label: wrongAmountGuestsLabel!, text: " O número de convidados deve ser \n maior ou igual a 1", width: CGFloat(250), height: 80, tag: 1)
                    if wrongAmountDrunkGuestsLabel?.superview == self.view {
                        wrongAmountDrunkGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else if num > 1000000 || textField.text!.count > 7 {
                    addWrongLabel(label: wrongAmountGuestsLabel!, text: " O número de convidados deve ser \n menor que 1000000", width: 250, height: 80, tag: 2)
                    if wrongAmountDrunkGuestsLabel?.superview == self.view {
                        wrongAmountDrunkGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else if let text = amountOfDrunkGuestsTextField.text, let numOfDrunkGuests = Int64(text), selected {
                    if num < numOfDrunkGuests {
                        addWrongLabel(label: wrongAmountGuestsLabel!, text: " O número de convidados que \n bebem não pode ser maior que \n o número de convidados", width: 250, height: 100, tag: 3)
                            if wrongAmountDrunkGuestsLabel?.superview == self.view {
                                wrongAmountDrunkGuestsLabel?.isHidden = true
                            }
                            nextButton.isEnabled = false
                    } else if wrongAmountDrunkGuestsLabel?.tag == 6 {
                        wrongAmountGuestsLabel!.removeFromSuperview()
                        wrongAmountDrunkGuestsLabel!.removeFromSuperview()
                        nextButton.isEnabled = true
                    }
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
                addWrongLabel(label: wrongAmountGuestsLabel!, text: "Número inválido", width: 100, height: 50, tag: 4)
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
                    addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: " O número de convidados que \n bebem deve ser maior ou igual a 1 ", width: 270, height: 80, tag: 5)
                    if wrongAmountGuestsLabel?.superview == self.view {
                        wrongAmountGuestsLabel?.isHidden = true
                    }
                    nextButton.isEnabled = false
                } else if let text = amountOfGuestsTextField.text {
                    if text.count != 0 {
                        if let numOfGuests = Int64(text), num > numOfGuests || textField.text!.count > 7 {
                            addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: " O número de convidados que \n bebem não pode ser maior que \n o número de convidados", width: 250, height: 100, tag: 6)
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
                        addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: " O número de convidados que \n bebem não pode ser maior que \n o número de convidados", width: 250, height: 100, tag: 6)
                        if wrongAmountGuestsLabel?.superview == self.view {
                            wrongAmountGuestsLabel?.isHidden = true
                        }
                        nextButton.isEnabled = false
                    }
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
                addWrongLabel(label: wrongAmountDrunkGuestsLabel!, text: "Número inválido", width: 100, height: 50, tag: 7)
                if wrongAmountGuestsLabel?.superview == self.view {
                    wrongAmountGuestsLabel?.isHidden = true
                }
                nextButton.isEnabled = false
            }
        }
    }
    
    func setWrongLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.textColor = red
        label.layer.borderWidth = 2
        label.layer.borderColor = red.cgColor
        label.layer.cornerRadius = 10
        label.isHidden = true
        label.tag = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        return label
    }
    
    func addWrongLabel(label: UILabel, text: String, width: CGFloat, height: CGFloat, tag: Int) {
        label.text = text
        label.tag = tag
        self.view.addSubview(label)
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(lessThanOrEqualTo: self.view.leadingAnchor, constant: 20)
        label.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: 20)
        label.isHidden = false
    }
}


