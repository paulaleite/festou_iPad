//
//  TasksTableViewCell.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 14/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import UIKit

class PartyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var donePercentage: UILabel!
    // implementar mostra das procentagem
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.shadowOpacity = 6
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowColor = UIColor.lightGray.cgColor
            containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
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
