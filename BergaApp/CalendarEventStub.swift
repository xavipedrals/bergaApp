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
            date: Commons.getDateFromString(date: "05-31-2017", format: "MM-dd-yyyy")!,
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event3 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-15-2017", format: "MM-dd-yyyy")!,
            name: "La Patum de Berga",
            type: .fair
        )
        
        let event4 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event5 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event6 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event7 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event8 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event9 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event10 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event11 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        let event12 = CalendarEvent(
            date: Date(),
            name: "Fira de Sant Isidre",
            type: .fair
        )
        
        return [event1, event2, event3]
    }
}
