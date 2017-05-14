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
    var isToday: Bool?
    var isEmpty: Bool?
    
    func initFrom(day: Day) {
        if day.number == 0 {
            setEmpty()
        }
        isToday = day.isToday
        numberLabel.textColor = isToday! ? UIColor.white : UIColor.darkGray
        todayBackground.backgroundColor = isToday! ? UIColor(r: 255, g: 52, b: 43) : UIColor.white
        numberLabel.text = String(day.number)
    }
    
    func setEmpty() {
        numberLabel.isHidden = true
        todayBackground.isHidden = true
    }
    
    func setSelected() {
        if (!isToday!) {
            todayBackground.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    func setUnselected() {
        if (!isToday!) {
            todayBackground.backgroundColor = UIColor.white
        }
    }
}
