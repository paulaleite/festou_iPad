//
//  TableViewControllerMenu.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MenuTableViewController: UITableViewController {
    
    var parties:[Party] =  []
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Festas"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            parties = try context!.fetch(Party.fetchRequest())
        } catch {
            print("Erro ao carregar festa")
            return
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") as! UITableViewCell
        cell.textLabel?.text = parties[indexPath.row].name
        cell.detailTextLabel?.text = "\(parties[indexPath.row].numOfGuests) convidados"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context?.delete(parties[indexPath.row])
            parties.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }

    @IBAction func addParty(_ sender: UIStoryboardSegue){
        if sender.source is TitleTableViewController{
            if let senderAdd = sender.source as? TitleTableViewController{
                if let party = senderAdd.party{
                    parties.append(party)
                    print("\nOK\n")
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let partyGuest = segue.destination as? GuestsTableViewController {
            partyGuest.partyTVC = self
        }
        if let partyTVC = segue.destination as? PartyTableViewController {
            partyTVC.party = parties[tableView.indexPathForSelectedRow!.row]
            partyTVC.menuTVC = self
        }
    }
    
}
