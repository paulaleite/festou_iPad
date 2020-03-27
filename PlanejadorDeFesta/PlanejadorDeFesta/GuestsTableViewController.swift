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

@available(iOS 13.0, *)
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
    
    var wrongValuesLabel:UILabel?
    
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
        amountOfDrunkGuestsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        amountOfGuestsTextField.delegate = self
        amountOfGuestsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableView.isUserInteractionEnabled = true
        
        wrongValuesLabel = setWrongLabel()
        
        nextButton.isEnabled = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let newWindowButton = UIButton(frame: CGRect(x: 20, y: 108, width: 147, height: 40))
            newWindowButton.backgroundColor = .purple
            newWindowButton.setTitle("New Window", for: .normal)
            newWindowButton.layer.cornerRadius = 10
            newWindowButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

            self.view.addSubview(newWindowButton)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let userActivity = NSUserActivity(activityType: ActivityIdentifier.create.rawValue)
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        selectedSection = indexPath.section
        
        // Alcoholic drinks checked
        if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: indexPath)!.accessoryType == .none {
            tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType = .checkmark
            selected = true
            drunkGuestsTableViewCell.isHidden.toggle()
            
            var numberOfGuests:Int?
            var numberOfDrunkGuests:Int?
            if let textField = amountOfGuestsTextField {
                if let text = textField.text, let num = Int(text) {
                    numberOfGuests = num
                }
            }
            
            if let textField = amountOfDrunkGuestsTextField {
                if let text = textField.text, let num = Int(text) {
                    numberOfDrunkGuests = num
                } else {
                    let text = "Número de convidados que bebem é inválido"
                    if let label = wrongValuesLabel {
                        addWrongLabel(label: label, text: text, width: 250, height: 80, tag: 1)
                    }
                }
            }
            
            if let num1 = numberOfGuests, let num2 = numberOfDrunkGuests {
                checkInputValues(numOfGuests: num1, numOfDrunkGuests: num2)
            }
            
        }
        // Alcoholic drinks unchecked
        else if selectedRow == 0 && selectedSection == 2 && tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            selected = false
            drunkGuestsTableViewCell.isHidden.toggle()
            
            if let textField = amountOfGuestsTextField {
                if let text = textField.text, let num = Int(text) {
                    checkInputValues(numOfGuests: num, numOfDrunkGuests: 0)
                }
            }
            
        }
    }
    
    func updateListViews() {
        let scenes = UIApplication.shared.connectedScenes
        let filteredScenes = scenes.filter { scene in
            guard let userInfo = scene.session.userInfo, let activityType = userInfo["type"] as? String, activityType == ActivityIdentifier.partiesList.rawValue
            else {
                return false
        }

        return true
      }
        filteredScenes.forEach { scene in
            UIApplication.shared.requestSceneSessionRefresh(scene.session)
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
            NotificationCenter.default.post(name: Notification.Name.partyCreated, object: nil)
            updateListViews()
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
    
    
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        var numberOfGuests:Int?
        var numberOfDrunkGuests:Int?
        
        if let textField = amountOfGuestsTextField {
            if let text = textField.text, let num = Int(text) {
                numberOfGuests = num
            } else {
                let text = "Número inválido"
                if let label = wrongValuesLabel {
                    addWrongLabel(label: label, text: text, width: 250, height: 80, tag: 1)
                }
                nextButton.isEnabled = false
            }
        }
        
        if let textField = amountOfDrunkGuestsTextField {
            if let text = textField.text, let num = Int(text) {
                numberOfDrunkGuests = num
            } else {
                if selected {
                    let text = "Número de convidados que bebem é inválido"
                    if let label = wrongValuesLabel {
                        addWrongLabel(label: label, text: text, width: 250, height: 80, tag: 1)
                    }
                    nextButton.isEnabled = false
                } else {
                    numberOfDrunkGuests = 0
                }
            }
        }
        
        if let num1 = numberOfGuests, let num2 = numberOfDrunkGuests {
            checkInputValues(numOfGuests: num1, numOfDrunkGuests: num2)
        }
    }
    
    
    func checkInputValues(numOfGuests: Int, numOfDrunkGuests: Int) {
        var text:String
        if (numOfGuests <= 0 || numOfDrunkGuests < 0) {
            text = "Os números devem maiores que 0"
            if let label = wrongValuesLabel {
                addWrongLabel(label: label, text: text, width: 250, height: 80, tag: 1)
            }
            nextButton.isEnabled = false
        } else if (numOfGuests >= 1000000 || numOfDrunkGuests >= 1000000) {
            text = "Os números devem ser menores que 1000000"
            if let label = wrongValuesLabel {
                addWrongLabel(label: label, text: text, width: 250, height: 80, tag: 1)
            }
            nextButton.isEnabled = false
        } else if (numOfGuests < numOfDrunkGuests) {
            text = "O número de consumidores de bebida alcoólica não pode ser maior que o número de convidados"
            if let label = wrongValuesLabel {
                addWrongLabel(label: label, text: text, width: 270, height: 120, tag: 2)
            }
            nextButton.isEnabled = false
        } else {
            if let label = wrongValuesLabel {
                label.removeFromSuperview()
            }
            nextButton.isEnabled = true
        }
    }
    
    func setWrongLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.textColor = red
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
        label.sizeToFit()
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
        label.isHidden = false
    }
}


