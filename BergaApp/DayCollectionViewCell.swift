//
//  DayCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var todayBackground: CustomView!
    
    func initFrom(day: Day) {
        numberLabel.textColor = day.isToday ? UIColor.white : UIColor.darkGray
        todayBackground.isHidden = day.isToday ? false : true
        numberLabel.text = String(day.number)
    }
}
