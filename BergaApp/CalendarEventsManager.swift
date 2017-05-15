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
    
    func getDaysNumberWithEvents(from: Date) -> [Int] {
        let calendar = Calendar.current
        let monthNumber = calendar.component(.month, from: from)
        let filteredEvents = calendarEvents.filter({
            let eventMonthNumber = calendar.component(.month, from: $0.date)
            return monthNumber == eventMonthNumber
        })
        let dayNumbers = filteredEvents.map({
            calendar.component(.day, from: $0.date)
        })
        return dayNumbers
    }
    
    func getEventsFor(day: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        let filteredEvents = calendarEvents.filter({
            calendar.startOfDay(for: $0.date) == calendar.startOfDay(for: day)
        })
        return filteredEvents
    }
}
