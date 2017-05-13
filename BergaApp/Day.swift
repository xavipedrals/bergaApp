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
    var events: [CalendarEvent]
    var isToday: Bool
    
    init(number: Int) {
        self.number = number
        self.events = []
        self.isToday = false
    }
}
