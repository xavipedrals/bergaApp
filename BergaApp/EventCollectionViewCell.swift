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
    
    func initCell(from: CalendarEvent) {
        nameLabel.text = from.name
    }
}
