//
//  NotificationCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 29/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func initCell(notification: ShopNotification) {
        notificationTitleLabel.text = notification.title
//        dateLabel.text = notification.date
        bodyLabel.text = notification.body
    }
}
