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
            
            let colorTop = UIColor(red: 231.0/255.0, green: 158.0/255.0, blue: 126.0/255.0, alpha: 1.0).cgColor // laranja
            let colorBottom = UIColor(red: 237.0/255.0, green: 145.0/255.0, blue: 177.0/255.0, alpha: 1.0).cgColor // rosa
            
            gl = CAGradientLayer()
            gl.colors = [colorTop, colorBottom]
            gl.locations = [0.0, 1.0]
            gl.frame = containerView.subviews[0].bounds
            gl.cornerRadius = 10
            gl.startPoint = CGPoint(x: 0, y: 0)
            gl.endPoint = CGPoint(x: 1, y: 1)
            containerView.subviews[0].layer.insertSublayer(gl, at: 0)

            containerView.layer.shadowOpacity = 10
            containerView.layer.shadowRadius = 3
            containerView.layer.shadowColor = UIColor.black.cgColor
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
