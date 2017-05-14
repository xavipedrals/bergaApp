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
    
    func getMonthEvents(date: Date) -> [Int] {
        let calendar = Calendar.current
        let monthNumber = calendar.component(.month, from: date)
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
        let filteredEvents = calendarEvents.filter({
            $0.date == day
        })
        return filteredEvents
    }
}
