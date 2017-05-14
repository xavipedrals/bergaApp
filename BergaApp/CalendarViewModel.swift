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
    
    let days = Variable<[Day]>([])
    let monthStr = Variable<String>("")
    let yearStr = Variable<String>("")
//    let today = Date()
    var monthPointer: Variable<Date>
    let disposeBag = DisposeBag()
    
    let CALENDAR_SECTION = 0
    let EVENTS_SECTION = 1
    
    var sections = [
        CalendarSection(header: "Calendar", items: []),
        CalendarSection(header: "Events", items: [])
    ]

    init() {
        monthPointer = Variable<Date>(Date().startOfMonth())
        
        monthPointer.asObservable()
            .map({ Commons.getStringFromDate(date: $0, format: "MMMM yyyy") })
            .subscribe(onNext: { monthYear in
                let monthYearArr = monthYear.components(separatedBy: " ")
                self.monthStr.value = monthYearArr[0].uppercased()
                self.yearStr.value = monthYearArr[1]
            })
            .addDisposableTo(disposeBag)
        
        monthPointer.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.setMonthDays()
            })
            .addDisposableTo(disposeBag)

    }
    
    func setMonthDays() {
        days.value.removeAll()
        days.value = CalendarDaysGenerator(from: monthPointer.value).generate()
    }
    
    func addAMonth() {
        monthPointer.value = monthPointer.value.nextMonth()
    }
    
    func substractAMonth() {
        monthPointer.value = monthPointer.value.previousMonth()
    }
}
