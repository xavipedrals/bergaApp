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
    
    var days = [Day]()
    let monthYearStr = Variable<String>("")
    var monthPointer: Variable<Date>
    let daysGenerator: MonthDaysGenerator
    
    let disposeBag = DisposeBag()
    
    let CALENDAR_SECTION = 0
    let EVENTS_SECTION = 1
    
    let sections = Variable<[CalendarSection]>([
        CalendarSection(header: "Calendar", items: []),
        CalendarSection(header: "Events", items: [])
    ])

    init() {
        monthPointer = Variable<Date>(Date().startOfMonth())
        daysGenerator = MonthDaysGenerator()
        
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
        
        monthPointer.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.setMonthDays()
            })
            .addDisposableTo(disposeBag)
        
        updateEventsSection(day: Date())
    }
    
    func setMonthDays() {
        days.removeAll()
        let daysWithEvents = CalendarEventsManager().getDaysNumberWithEvents(from: monthPointer.value)
        days = daysGenerator.generate(from: monthPointer.value, markedDays: daysWithEvents)
        updateDaysSection()
    }
    
    func updateDaysSection() {
        var items = [CalendarModelType]()
        for day in days {
            let calendarModel = CalendarModelType.day(day)
            items.append(calendarModel)
        }
        let calendarSection = CalendarSection(original: sections.value[CALENDAR_SECTION], items: items)
        sections.value[CALENDAR_SECTION] = calendarSection
    }
    
    func updateEventsSection(dayAt: Int) {
        let dayNumber = days[dayAt].number
        if let date = daysGenerator.getDay(number: dayNumber) {
            updateEventsSection(day: date)
        }
    }
    
    func updateEventsSection(day: Date) {
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
}
