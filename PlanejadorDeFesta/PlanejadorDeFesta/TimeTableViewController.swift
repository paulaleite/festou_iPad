//
//  TableViewControllerTime.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TimeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var amountOfHoursPicker: UIPickerView!
    
    public var party:Party?
    
    public var partyTVC:MenuTableViewController?
    
    var context:NSManagedObjectContext?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Adicionada para funcionar com Table View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Adicionada para funcionar com Table View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountOfHoursPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountOfHoursPickerData[row]
    }
    
    var amountOfHoursPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        super.viewDidLoad()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        amountOfHoursPickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        
        self.amountOfHoursPicker.delegate = self
        self.amountOfHoursPicker.dataSource = self
    }
    
    @IBAction func next (_ sender: Any) {
        let selectedValue = Int32(amountOfHoursPickerData[amountOfHoursPicker.selectedRow(inComponent: 0)])
        
        if let newNumOfHours = selectedValue {
            party!.numOfHours = newNumOfHours
        }
    
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "partyName")
        if let partyTitle = controller as? TitleTableViewController {
            partyTitle.party = party
            partyTitle.partyTVC = partyTVC
        }
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
}
