//
//  CalendarEventStub.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class CalendarEventStub {
    
    func getStub() -> [CalendarEvent] {
        
        let event1 = CalendarEvent(
            date: Date(),
            name: "Festa major de Graugés",
            type: .townFest
        )
        
        let event2 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        return [event1, event2]
    }
}
