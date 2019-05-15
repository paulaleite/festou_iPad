//
//  TasksTableViewCell.swift
//  PlanejadorDeFesta
//
//  Created by Lia Kassardjian on 14/05/19.
//  Copyright © 2019 Juliana Vigato Pavan. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.subviews[0].layer.cornerRadius = 10
            
            var gl:CAGradientLayer!
            
            let colorTop = UIColor(red: 255/255, green: 132/255, blue: 78/255, alpha: 1.0).cgColor // laranja
            let colorBottom = UIColor(red: 123/255, green: 43/255, blue: 71/255, alpha: 1.0).cgColor // vinho
            
            gl = CAGradientLayer()
            gl.colors = [colorTop, colorBottom]
            gl.locations = [0.2, 0.90]
            gl.frame = containerView.subviews[0].bounds
            gl.cornerRadius = 10
            gl.startPoint = CGPoint(x: 0, y: 0)
            gl.endPoint = CGPoint(x: 1, y: 1)
            containerView.subviews[0].layer.insertSublayer(gl, at: 0)

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
