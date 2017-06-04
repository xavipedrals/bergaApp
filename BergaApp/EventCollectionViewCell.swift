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
    @IBOutlet weak var placeLabel: UILabel!
    
    func initCell(from event: CalendarEvent) {
        nameLabel.text = event.name
        eventIcon.image = UIImage(named: event.type.rawValue)
        eventIcon.iconTint = UIColor.darkGray
        placeLabel.text = event.address.town
    }
}
