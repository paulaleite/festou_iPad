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

@available(iOS 13.0, *)
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
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.rowHeight = 178
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
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
//        NotificationCenter.default.post(name: Notification.Name.partyCreated, object: nil)
//        updateListViews()
        tableView.reloadData()
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
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    // Load cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") as! PartyMenuTableViewCell
        cell.title.text = parties[indexPath.row].name
        let numOfGuests = parties[indexPath.row].numOfGuests
        if numOfGuests > 1 {
            cell.subtitle.text = "\(numOfGuests) convidados"
        } else {
            cell.subtitle.text = "\(numOfGuests) convidado"
        }
        let pRed = Double(parties[indexPath.row].red)
        let pGreen = Double(parties[indexPath.row].green)
        let pBlue = Double(parties[indexPath.row].blue)
        cell.containerView.backgroundColor = UIColor(red: CGFloat(pRed/255),
                                                     green: CGFloat(pGreen/255),
                                                     blue: CGFloat(pBlue/255),
                                                     alpha: 1)

        return cell
    }
    
    // Allows deleting
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context?.delete(parties[indexPath.row])
            parties.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Adding "noPartyImage" in case there are no more parties
            if parties.count == 0 {
                noPartyImage.frame = CGRect(x: 0, y: 0, width: 390, height: 300)
                self.view.addSubview(noPartyImage)
                noPartyImage.center.x = self.view.center.x
                noPartyImage.center.y = self.view.center.y - 80
            }
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    // Allows editing row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Method that allows the Exit action
    @IBAction func addParty(_ sender: UIStoryboardSegue){
        if #available(iOS 13.0, *) {
            if sender.source is TitleTableViewController{
                if let senderAdd = sender.source as? TitleTableViewController{
                    if let party = senderAdd.newParty{
                        parties.append(party)
                        noPartyImage.removeFromSuperview()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Prepare for segue from table view cells
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if #available(iOS 13.0, *) {
            if let partyGuest = segue.destination as? GuestsTableViewController {
                partyGuest.partyTVC = self
                if let _ = context{
                    partyGuest.party = Party(context: context!)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        if let partyTVC = segue.destination as? PartyTableViewController {
            partyTVC.party = parties[tableView.indexPathForSelectedRow!.row]
            partyTVC.menuTVC = self
        }
    }
    
}
