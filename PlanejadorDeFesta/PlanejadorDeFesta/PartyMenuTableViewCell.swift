//
//  PartyMenuTableViewCell.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 15/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import UIKit

class PartyMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel! {
        didSet {
            title.textColor = UIColor(red: 255/255, green: 235/255, blue: 227/255, alpha: 1)
        }
    }
    
    @IBOutlet weak var subtitle: UILabel! {
        didSet {
            subtitle.textColor = UIColor(red: 255/255, green: 235/255, blue: 227/255, alpha: 1)
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 6
            containerView.layer.shadowRadius = 4
            containerView.layer.shadowColor = UIColor.lightGray.cgColor
            containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
            containerView.backgroundColor = UIColor(red: 123/255, green: 43/255, blue: 71/255, alpha: 1)
            
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
