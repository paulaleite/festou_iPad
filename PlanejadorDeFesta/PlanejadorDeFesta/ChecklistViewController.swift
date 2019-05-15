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
    
    public var section:Int!
    
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
                    tasks = []
                    for i in 0..<(p.has!.count) {
                        let t = p.has![i] as! Tasks
                        if t.typeOfSection == Int16(section) {
                            tasks.append(t)
                        }
                    }
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
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else if tasks[selectedRow].checkConclusion {
            tableView.cellForRow(at: indexPath)?.tintColor = UIColor.lightGray
            tasks[selectedRow].checkConclusion = false
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = tasks {
            return tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! UITableViewCell
        if (tasks[indexPath.row].checkConclusion) {
            cell.tintColor = UIColor.green
        } else {
            cell.tintColor = UIColor.lightGray
        }
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
}
