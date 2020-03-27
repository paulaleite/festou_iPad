//
//  TableViewControllerTitle.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 13.0, *)
class TitleTableViewController: UITableViewController, UITextFieldDelegate {
    
    let colors:[[Int16]] = [[158, 133, 244],    // roxo
                            [0, 183, 157],      // verde-agua
                            [255,134,78],       // laranja
                            [242,114,135]]      // rosa
    
    @IBOutlet weak var partyTitleTextField: UITextField!
    
    var partyTitle: String!
    
    public var party:Party?
    
    public var partyTVC:MenuTableViewController?
    
    public var task:Tasks?
    
    var context:NSManagedObjectContext?
    
    var newParty:Party?
    
    var wrongTitleLabel:UILabel?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        partyTitleTextField.delegate = self
        partyTitleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let red = UIColor(red: 214/255, green: 59/255, blue: 87/255, alpha: 1)
        wrongTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        wrongTitleLabel!.textAlignment = NSTextAlignment.center
        wrongTitleLabel!.numberOfLines = 0
        wrongTitleLabel!.textColor = red
        wrongTitleLabel!.translatesAutoresizingMaskIntoConstraints = false
        wrongTitleLabel!.widthAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        wrongTitleLabel!.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        addButton.isEnabled = false
    }
    
    
    func createTasks() -> [[String]]{
        var tasks:[[String]] = [[],[],[]]
        if let _ = newParty {
            
            let hours = Int(newParty!.numOfHours)
            let guests = Int(newParty!.numOfGuests)
            
            // Insere comida
            if let meal = newParty?.doesHaveMeal {
                if meal { // se haverá refeição
                    tasks[0].append("Providenciar \(guests * 2 * hours) salgadinhos")
                    
                    let carne = guests * 150
                    if carne > 1000 {
                        tasks[0].append("Providenciar \(Double(carne)/1000) kg de carne")
                    } else {
                        tasks[0].append("Providenciar \(carne) g de carne")
                    }
                    
                    let acomp = guests * 50
                    if acomp > 1000 {
                        tasks[0].append("Providenciar \(Double(acomp)/1000) kg de acompanhamento")
                    } else {
                        tasks[0].append("Providenciar \(acomp) g de acompanhamento")
                    }
                } else {
                    tasks[0].append("Providenciar \(guests * 4 * hours) salgadinhos")
                }
            }
            tasks[0].append("Providenciar \(guests * 5) docinhos")
            if guests > 1 {
                tasks[0].append("Providenciar \(guests) porções de sobremesa")
            } else {
                tasks[0].append("Providenciar \(guests) porção de sobremesa")
            }
            
            // Insere bebidas
            if let drinks = newParty?.doesDrink {
                var litros:Int
                if drinks { // se haverá bebida alcoólica
                    litros = Int(newParty!.numOfDrunkGuests) * 150 * hours
                    if litros >= 1000 {
                        tasks[1].append("Providenciar \(Double(litros)/1000) L de bebida alcoólica")
                    } else {
                        tasks[1].append("Providenciar \(litros) mL de bebida alcoólica")
                    }
                    
                    litros = ((guests - Int(newParty!.numOfDrunkGuests)) * 100 + Int((Double(newParty!.numOfDrunkGuests)/2) * 100)) * hours
                    if litros >= 1000 {
                        tasks[1].append("Providenciar \(Double(litros)/1000) L de bebida não-alcoólica")
                    } else {
                        tasks[1].append("Providenciar \(litros) mL de bebida não-alcoólica")
                    }
                    
                } else {
                    litros = guests * 100 * hours
                    if litros >= 1000 {
                        tasks[1].append("Providenciar \(Double(litros)/1000) L de bebida não-alcoólica")
                    } else {
                        tasks[1].append("Providenciar \(litros) mL de bebida não-alcoólica")
                    }
                }
            }
            
            // Insere utensílios
            if guests > 1 {
                tasks[2].append("Providenciar \(guests) jogos de talheres")
                tasks[2].append("Providenciar \(guests) pratos de comida")
                tasks[2].append("Providenciar \(guests) pratos de sobremesa")
                tasks[2].append("Providenciar \(guests) copos")
            } else {
                tasks[2].append("Providenciar \(guests) jogo de talheres")
                tasks[2].append("Providenciar \(guests) prato de comida")
                tasks[2].append("Providenciar \(guests) prato de sobremesa")
                tasks[2].append("Providenciar \(guests) copo")
            }
        }
        
        return tasks
    }
    
    func addTasks() {
        let names = createTasks()
        for i in 0..<(names.count) { // laco das secoes
            for s in names[i] { // lacos das tarefas
                if let context = context{
                    task = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context) as! Tasks
                    task?.name = s
                    task?.typeOfSection = Int16(i+1)
                    task?.checkConclusion = false
                    if let t = task {
                        newParty?.addToHas(t)
                    }
                }
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if partyTitleTextField.text != nil,
            partyTitleTextField.text!.count > 0 {
            partyTitle = partyTitleTextField.text!
        }
        
        if partyTitle != nil {
            if let _ = partyTVC {
                if let context = context {
                    newParty = NSEntityDescription.insertNewObject(forEntityName: "Party", into: context) as! Party
                    if let newPartyTitle = partyTitle {
                        newParty?.numOfGuests = Int32(party!.numOfGuests)
                        newParty?.doesDrink = party!.doesDrink
                        newParty?.numOfDrunkGuests = Int32(party!.numOfDrunkGuests)
                        newParty?.doesHaveMeal = party!.doesHaveMeal
                        newParty?.numOfHours = party!.numOfHours
                        newParty?.name = newPartyTitle
                        let i = Int.random(in: 0 ... colors.count-1)
                        newParty?.red = colors[i][0]
                        newParty?.green = colors[i][1]
                        newParty?.blue = colors[i][2]
                        
                        context.delete(party!)
                    }
                    partyTVC!.parties.append(newParty!)
                    newParty?.id = UUID().uuidString
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
            addTasks()
            NotificationCenter.default.post(name: Notification.Name.partyCreated, object: nil)
            updateListViews()
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if let textField = partyTitleTextField {
            if let text = textField.text {
                if text.hasPrefix(" ") || text.count == 0 {
                    addWrongLabel(label: wrongTitleLabel!, text: "Nome inválido")
                    addButton.isEnabled = false
                } else {
                    wrongTitleLabel!.removeFromSuperview()
                    addButton.isEnabled = true
                }
            }
        }
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func addWrongLabel(label: UILabel, text: String) {
        self.view.addSubview(label)
        label.sizeToFit()
        label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
        label.isHidden = false
        label.text = text
    }
    
}
