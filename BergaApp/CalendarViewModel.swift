//
//  CalendarViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel {
    
    let monthYearStr = Variable<String>("")
    var monthPointer: Variable<Date>
    let daysGenerator: MonthDaysGenerator
    let calendarEventsManager: CalendarEventsManager
    
    let disposeBag = DisposeBag()
    
    let CALENDAR_SECTION = 0
    let EVENTS_CONTAINER_SECTION = 1
    
    let sections = Variable<[CalendarSection]>([
        CalendarSection(header: "Days", items: []),
        CalendarSection(header: "EventsContainer", items: [])
    ])
    
    let events = Variable<[CalendarEvent]>([])
    let eventsSection = Variable<[CalendarEventSection]>([
        CalendarEventSection(header: "Events", items: [])
    ])
    
    var eventsCount: Int {
        get {
            return sections.value[EVENTS_CONTAINER_SECTION].items.count
        }
    }
    var daysCount: Int {
        get {
            return sections.value[CALENDAR_SECTION].items.count
        }
    }

    init() {
        monthPointer = Variable<Date>(Date().startOfMonth())
        daysGenerator = MonthDaysGenerator()
        calendarEventsManager = CalendarEventsManager()
        
        generateMonthYearStringWhenMonthChanges()
        generateDaysWhenMonthChanges()
        updateEventsSection(day: Date())
        
        events.asObservable()
            .subscribe(onNext: { events in
                let eventsSection = CalendarEventSection(original: self.eventsSection.value[0], items: events)
                self.eventsSection.value[0] = eventsSection
            })
            .addDisposableTo(disposeBag)
    }
    
    private func generateMonthYearStringWhenMonthChanges() {
        monthPointer.asObservable()
            .map({
                var dateStr = Commons.getStringFromDate(date: $0, format: "MMMM yyyy")
                dateStr = dateStr.replacingOccurrences(of: "de ", with: "")
                dateStr = dateStr.replacingOccurrences(of: "d’", with: "")
                dateStr = dateStr.replacingOccurrences(of: "d'", with: "")
                return dateStr.capitalized
            })
            .bind(to: monthYearStr)
            .addDisposableTo(disposeBag)
    }
    
    private func generateDaysWhenMonthChanges() {
        monthPointer.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.updateDaysSection()
                self.cleanEventsSection()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func updateDaysSection() {
        let daysWithEvents = calendarEventsManager.getDaysNumberWithEvents(from: monthPointer.value)
        let days = daysGenerator.generate(from: monthPointer.value, markedDays: daysWithEvents)
        let calendarModels = generateCalendarModels(from: days)
        let calendarSection = CalendarSection(original: sections.value[CALENDAR_SECTION], items: calendarModels)
        sections.value[CALENDAR_SECTION] = calendarSection
    }
    
    private func generateCalendarModels(from days: [Day]) -> [CalendarModelType] {
        var items = [CalendarModelType]()
        for day in days {
            let calendarModel = CalendarModelType.day(day)
            items.append(calendarModel)
        }
        return items
    }
    
    func updateEventsSection(dayAt: IndexPath) {
        if let day = getDay(at: dayAt) {
            if let date = daysGenerator.getDate(number: day.number) {
                updateEventsSection(day: date)
            }
        }
    }
    
    private func updateEventsSection(day: Date) {
        events.value = CalendarEventsManager().getEventsFor(day: day)
        var items = [CalendarModelType]()
        if events.value.count > 0 {
            let calendarModel = CalendarModelType.calendarEvent(events.value[0])
            items.append(calendarModel)
        }
        let eventsSection = CalendarSection(original: sections.value[EVENTS_CONTAINER_SECTION], items: items)
        sections.value[EVENTS_CONTAINER_SECTION] = eventsSection
    }
    
    func addAMonth() {
        monthPointer.value = monthPointer.value.nextMonth()
        cleanEventsSection()
    }
    
    func substractAMonth() {
        monthPointer.value = monthPointer.value.previousMonth()
        cleanEventsSection()
    }
    
    func cleanEventsSection() {
        events.value = []
        let eventsSection = CalendarSection(original: sections.value[EVENTS_CONTAINER_SECTION], items: [])
        sections.value[EVENTS_CONTAINER_SECTION] = eventsSection
    }
    
    func getDay(at: IndexPath) -> Day? {
        let calendarModel = sections.value[CALENDAR_SECTION].items[at.row]
        switch calendarModel {
        case .day(let day):
            return day
            
        default:
            return nil
        }
    }
    
    func getEvent(at: IndexPath) -> CalendarEvent? {
        if at.row < events.value.count {
            return events.value[at.row]
        }
        return nil
        
    }
}

