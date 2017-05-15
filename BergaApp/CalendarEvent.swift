//
//  CalendarEvent.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

enum CalendarEventType: String {
    case sport = "running"
    case townFest = "majorFest"
    case fair = "carousel"
}

struct CalendarEvent {
    
    var date: Date
    var name: String
    var type: CalendarEventType
    var localization: String?
    
    init(date: Date, name: String, type: CalendarEventType) {
        self.date = date
        self.name = name
        self.type = type
    }
}
