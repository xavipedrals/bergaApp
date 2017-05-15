//
//  EventCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventIcon: IconImage!
    
    func initCell(from: CalendarEvent) {
        nameLabel.text = from.name
        eventIcon.image = UIImage(named: from.type.rawValue)
        eventIcon.iconTint = UIColor.gray
    }
}
