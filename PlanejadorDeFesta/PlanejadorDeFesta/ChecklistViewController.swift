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
    
    var attributeString:NSMutableAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        checklistImage.image = UIImage(named: imageName)
        
        checklistTV.dataSource = self
        checklistTV.delegate = self
        checklistTV.rowHeight = 65
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
            tasks[selectedRow].checkConclusion = true
            let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            cell.taskImage.image = UIImage(named: "Check")
            
            attributeString = NSMutableAttributedString(string: tasks[indexPath.row].name!)
            attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString!.length))
            cell.taskLabel?.attributedText = attributeString!
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        } else if tasks[selectedRow].checkConclusion {
            tasks[selectedRow].checkConclusion = false
            let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            cell.taskImage.image = nil 
            
            attributeString = NSMutableAttributedString(string: tasks[indexPath.row].name!)
            attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
            cell.taskLabel?.attributedText = attributeString
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        if (tasks[indexPath.row].checkConclusion) {
            attributeString = NSMutableAttributedString(string: tasks[indexPath.row].name!)
            attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString!.length))
            cell.taskLabel?.attributedText = attributeString!
            
            cell.taskImage.image = UIImage(named: "Check")
        } else {
            cell.taskImage.image = UIImage(named: "Uncheck")
        }
        cell.taskLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
}
