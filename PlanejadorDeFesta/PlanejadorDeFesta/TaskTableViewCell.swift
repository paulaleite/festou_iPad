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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
