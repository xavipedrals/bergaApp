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
    let days = Variable<[Day]>([])
    let events = Variable<[CalendarEvent]>([])
    let disposeBag = DisposeBag()


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
        self.days.value = days
    }
    
    func updateEvents(dayNumber: Int) {
        let index = days.value.index(where: { $0.number == dayNumber })
        if let index = index {
            if let date = daysGenerator.getDate(number: days.value[index].number) {
                updateEventsSection(day: date)
            }
        }
    }
    
    private func updateEventsSection(day: Date) {
        events.value = CalendarEventsManager().getEventsFor(day: day)
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
    }

}

