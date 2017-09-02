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
        let daysDiff = Date().interval(ofComponent: .day, fromDate: notification.date)
        if daysDiff == 0 {
            dateLabel.text = "Avui"
        }
        else if daysDiff == 1 {
            dateLabel.text = "Ahir"
        }
        else if daysDiff <= 7 {
            dateLabel.text = "Fa " + String(daysDiff) + " dies"
        }
        else {
            dateLabel.text = notification.date.getString(format: .shopNotification)
        }
        bodyLabel.text = notification.body
    }
}
