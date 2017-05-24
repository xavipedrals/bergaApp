//
//  NotificationTableViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func initCell(from notification: ShopNotification) {
        titleLabel.text = notification.title
        bodyLabel.text = notification.body
    }

}
