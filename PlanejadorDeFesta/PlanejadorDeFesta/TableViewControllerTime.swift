//
//  TableViewControllerTime.swift
//  PlanejadorDeFesta
//
//  Created by Juliana Vigato Pavan on 09/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import Foundation
import UIKit

class TableViewControllerTime: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var amountOfHoursPicker: UIPickerView!
    
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
        
        amountOfHoursPickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        
        self.amountOfHoursPicker.delegate = self
        self.amountOfHoursPicker.dataSource = self
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
}
