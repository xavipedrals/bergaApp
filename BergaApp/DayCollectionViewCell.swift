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
    @IBOutlet weak var eventsMarkerView: CustomView!
    
    var isToday: Bool?
    var isEmpty: Bool?
    
    
    func initFrom(day: Day) {
        configureEmpty(day.number)
        isToday = day.isToday
        todayBackground.backgroundColor = isToday! ? UIColor(r: 255, g: 52, b: 43) : UIColor.clear
        numberLabel.textColor = isToday! ? UIColor.white : UIColor.black
        numberLabel.text = String(day.number)
        eventsMarkerView.isHidden = (!day.hasEvents || day.isToday)
    }
    
    func configureEmpty(_ num: Int) {
        isEmpty = num == 0
        numberLabel.isHidden = isEmpty!
        todayBackground.isHidden = isEmpty!
    }
    
    func setSelected() {
        if (!isToday!) {
            todayBackground.backgroundColor = Colors.red
            numberLabel.textColor = UIColor.white
        }
    }
    
    func setUnselected() {
        if (!isToday!) {
            todayBackground.backgroundColor = UIColor.clear
            numberLabel.textColor = UIColor.black
        }
    }
}
