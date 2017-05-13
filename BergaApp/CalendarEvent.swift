//
//  CalendarEvent.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

enum CalendarEventType {
    case sport
    case townFest
    case fair
}

class CalendarEvent {
    
    var date: Date?
    var title: String?
    var type: CalendarEventType?

}
