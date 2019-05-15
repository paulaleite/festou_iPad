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
            tableView.cellForRow(at: indexPath)?.tintColor = UIColor(red: 123/255, green: 43/255, blue: 71/255, alpha: 1)
            tasks[selectedRow].checkConclusion = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            attributeString = NSMutableAttributedString(string: tasks[indexPath.row].name!)
            attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString!.length))
            tableView.cellForRow(at: indexPath)?.textLabel?.attributedText = attributeString!
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else if tasks[selectedRow].checkConclusion {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tasks[selectedRow].checkConclusion = false
            attributeString = NSMutableAttributedString(string: tasks[indexPath.row].name!)
            attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
            tableView.cellForRow(at: indexPath)?.textLabel?.attributedText = attributeString
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
            attributeString = NSMutableAttributedString(string: tasks[indexPath.row].name!)
            attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString!.length))
            cell.textLabel?.attributedText = attributeString!
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
}
