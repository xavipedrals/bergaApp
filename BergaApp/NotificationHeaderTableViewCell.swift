//
//  NotificationHeaderTableViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 15/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class NotificationHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func initCell(isNewest: Bool, count: Int) {
        if isNewest {
            titleLabel.text = "Novetats (\(count))"
            iconImageView.image = UIImage(named: "megaphone")
        }
        else {
            titleLabel.text = "Llegides"
            iconImageView.image = UIImage(named: "Shape")
        }
    }

}
