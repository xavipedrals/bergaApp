//
//  CalendarEventsManager.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class CalendarEventsManager {
    
    var calendarEvents = [CalendarEvent]()
    
    init() {
        loadEvents()
    }
    
    func loadEvents() {
        calendarEvents = CalendarEventStub().getStub()
    }
    
    func getEventsFor(day: Date) -> [CalendarEvent] {
        let filteredEvents = calendarEvents.filter({
            $0.date == day
        })
        return filteredEvents
    }
}
