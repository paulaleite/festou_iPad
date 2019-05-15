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

class TitleTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var partyTitleTextField: UITextField!
    
    var partyTitle: String!
    
    public var party:Party?
    
    public var partyTVC:MenuTableViewController?
    
    public var task:Tasks?
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        partyTitleTextField.delegate = self
    }
    
    
    func createTasks() -> [[String]]{
        var tasks:[[String]] = [[],[],[]]
        if let _ = party {
            
            let hours = Int(party!.numOfHours)
            let guests = Int(party!.numOfGuests)
            
            // Insere comida
            if let meal = party?.doesHaveMeal {
                if meal { // se haverá refeição
                    tasks[0].append("Providenciar \(guests * 5) salgadinhos")
                    
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
                    tasks[0].append("Providenciar \(guests * 10) salgadinhos")
                }
            }
            tasks[0].append("Providenciar \(guests * 5) docinhos")
            tasks[0].append("Providenciar \(guests) porções de sobremesa")
            
            // Insere bebidas
            if let drinks = party?.doesDrink {
                var litros:Int
                if drinks { // se haverá bebida alcoólica
                    litros = Int(party!.numOfDrunkGuests) * 300 * hours
                    if litros > 1000 {
                        tasks[1].append("Providenciar \(Double(litros)/1000) L de bebida alcoólica")
                    } else {
                        tasks[1].append("Providenciar \(litros) mL de bebida alcoólica")
                    }
                    
                    litros = (guests - Int(party!.numOfDrunkGuests)) * 300 * hours
                    if litros > 1000 {
                        tasks[1].append("Providenciar \(Double(litros)/1000) L de bebida não-alcoólica")
                    } else {
                        tasks[1].append("Providenciar \(litros) mL de bebida não-alcoólica")
                    }
                    
                } else {
                    litros = guests * 300 * hours
                    if litros > 1000 {
                        tasks[1].append("Providenciar \(Double(litros)/1000) L de bebida não-alcoólica")
                    } else {
                        tasks[1].append("Providenciar \(litros) mL de bebida não-alcoólica")
                    }
                }
            }
            
            // Insere utensílios
            tasks[2].append("Providenciar \(guests) jogos de talheres")
            tasks[2].append("Providenciar \(guests) pratos")
            tasks[2].append("Providenciar \(guests) copos")
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
                        party?.addToHas(t)
                    }
                }
            }
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
                    if let newPartyTitle = partyTitle {
                        party!.name = newPartyTitle
                    }
                    partyTVC!.parties.append(party!)
                    if let id = partyTVC?.parties.count {
                        party!.id = Int32(id)
                    }
                    //(UIApplication.shared.delegate as! AppDelegate).saveContext()
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
            addTasks()
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
