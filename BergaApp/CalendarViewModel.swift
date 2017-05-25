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
    
    private let CALENDAR_SECTION = 0
    private let EVENTS_SECTION = 1
    
    let sections = Variable<[CalendarSection]>([
        CalendarSection(header: "Days", items: []),
        CalendarSection(header: "Events", items: [])
    ])

    init() {
        monthPointer = Variable<Date>(Date().startOfMonth())
        daysGenerator = MonthDaysGenerator()
        calendarEventsManager = CalendarEventsManager()
        
        generateMonthYearStringWhenMonthChanges()
        generateDaysWhenMonthChanges()
        updateEventsSection(day: Date())
    }
    
    private func generateMonthYearStringWhenMonthChanges() {
        monthPointer.asObservable()
            .map({
                var dateStr = Commons.getStringFromDate(date: $0, format: "MMMM yyyy")
                dateStr = dateStr.replacingOccurrences(of: "de ", with: "")
                dateStr = dateStr.replacingOccurrences(of: "d’", with: "")
                dateStr = dateStr.replacingOccurrences(of: "d'", with: "")
                return dateStr.uppercased()
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
        let events = CalendarEventsManager().getEventsFor(day: day)
        var items = [CalendarModelType]()
        for event in events {
            let calendarModel = CalendarModelType.calendarEvent(event)
            items.append(calendarModel)
        }
        let eventsSection = CalendarSection(original: sections.value[EVENTS_SECTION], items: items)
        sections.value[EVENTS_SECTION] = eventsSection
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
        let eventsSection = CalendarSection(original: sections.value[EVENTS_SECTION], items: [])
        sections.value[EVENTS_SECTION] = eventsSection
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
        let calendarModel = sections.value[EVENTS_SECTION].items[at.row]
        switch calendarModel {
        case .calendarEvent(let event):
            return event
            
        default:
            return nil
        }
    }
}

