//
//  TaskTableViewCell.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 16/05/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var taskButton: UIButton! {
        didSet {
            taskButton.layer.borderWidth = 2
            taskButton.layer.borderColor = UIColor(red: 47/255, green: 148/255, blue: 179/255, alpha: 1).cgColor
            taskButton.layer.cornerRadius = 0.5 * taskButton.frame.width
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
