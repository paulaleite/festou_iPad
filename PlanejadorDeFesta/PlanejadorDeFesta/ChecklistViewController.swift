//
//  ChecklistViewController.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 14/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import UIKit
import CoreData

class ChecklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var imageName:String!
    
    public var party:Party!
    
    public var tasks:[Tasks]!
    
    @IBOutlet weak var checklistTV: UITableView!
    
    @IBOutlet weak var checklistImage: UIImageView!
    
    var context:NSManagedObjectContext?
    
    var selectedRow:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        checklistImage.image = UIImage(named: imageName)
        
        checklistTV.dataSource = self
        checklistTV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            var parties:[Party] = []
            parties = try context!.fetch(Party.fetchRequest())
            
            for p in parties{
                if p.id == party.id {
                    party = p
                }
            }
        } catch {
            print("Erro ao carregar eventos")
            return
        }
        checklistTV.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        
        if !tasks[selectedRow].checkConclusion {
            tableView.cellForRow(at: indexPath)?.tintColor = UIColor.green
            tasks[selectedRow].checkConclusion = true
        } else if tasks[selectedRow].checkConclusion {
            tableView.cellForRow(at: indexPath)?.tintColor = UIColor.lightGray
            tasks[selectedRow].checkConclusion = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = party.has{
            return party.has!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! UITableViewCell
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
}
