//
//  PartyTableViewController.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 14/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import UIKit
import CoreData

class PartyTableViewController: UITableViewController {

    public var party:Party?
    
    public var menuTVC:MenuTableViewController?
    
    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let party = party {
            navigationItem.title = party.name
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tasks = segue.destination as? ChecklistViewController {
            var name:String?
            var title:String?
            var section:Int?
            if segue.identifier == "food"{
                name = "Plate"
                title = "Comida"
                section = 1
            } else if segue.identifier == "drinks" {
                name = "Drink"
                title = "Bebida"
                section = 2
            } else if segue.identifier == "utensils" {
                name = "Utensils"
                title = "Utensílios"
                section = 3
            }
            if let n = name, let t = title, let s = section {
                tasks.imageName = n
                tasks.navigationItem.title = t
                tasks.section = s
            }
            tasks.party = party
        }
    }

}
