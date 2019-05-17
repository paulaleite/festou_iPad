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
    
    var noPartyImage:UIImageView = UIImageView(image: UIImage(named: "NoParty"))
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Festas"
        tableView.rowHeight = 178
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            parties = try context!.fetch(Party.fetchRequest())
        } catch {
            print("Erro ao carregar festa")
            return
        }
        if parties.count == 0 {
            noPartyImage.frame = CGRect(x: 0, y: 0, width: 390, height: 300)
            self.view.addSubview(noPartyImage)
            noPartyImage.center.x = self.view.center.x
            noPartyImage.center.y = self.view.center.y - 80
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") as! PartyMenuTableViewCell
        cell.title.text = parties[indexPath.row].name
        cell.subtitle.text = "\(parties[indexPath.row].numOfGuests) convidados"
        let pRed = Double(parties[indexPath.row].red)
        let pGreen = Double(parties[indexPath.row].green)
        let pBlue = Double(parties[indexPath.row].blue)
        cell.containerView.backgroundColor = UIColor(red: CGFloat(pRed/255),
                                                     green: CGFloat(pGreen/255),
                                                     blue: CGFloat(pBlue/255),
                                                     alpha: 1)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context?.delete(parties[indexPath.row])
            parties.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if parties.count == 0 {
                noPartyImage.frame = CGRect(x: 0, y: 0, width: 390, height: 300)
                self.view.addSubview(noPartyImage)
                noPartyImage.center.x = self.view.center.x
                noPartyImage.center.y = self.view.center.y - 80
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }

    @IBAction func addParty(_ sender: UIStoryboardSegue){
        if sender.source is TitleTableViewController{
            if let senderAdd = sender.source as? TitleTableViewController{
                if let party = senderAdd.newParty{
                    parties.append(party)
                    noPartyImage.removeFromSuperview()
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
