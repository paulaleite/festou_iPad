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
    
    @IBOutlet weak var taskView: UIView! {
        didSet {
            taskView.layer.borderWidth = 2
            taskView.layer.borderColor = UIColor(red: 47/255, green: 148/255, blue: 179/255, alpha: 1).cgColor
            taskView.layer.cornerRadius = 0.5 * taskView.frame.width
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
