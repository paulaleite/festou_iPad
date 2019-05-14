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
    
    func createTasks() {
        let names = [["Fazer busca de preços","Providenciar comida","Estocar comida","Verificar comida"],["Comprar bebidas"],["Comprar garfos"]]
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
            createTasks()
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
