//
//  Day.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

struct Day {
    
    var number: Int
    var hasEvents: Bool
    var isToday: Bool
    
    init(number: Int) {
        self.number = number
        self.hasEvents = false
        self.isToday = false
    }
}
