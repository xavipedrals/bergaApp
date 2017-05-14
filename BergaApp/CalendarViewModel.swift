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
    let today = Date()
    var todayDayNumber: Int
    var todayMonthNumber: Int
    var todayYearNumber: Int

    var monthPointer: Variable<Date>
    let disposeBag = DisposeBag()
    
    init() {
        let calendar = Calendar.current
        todayDayNumber = calendar.component(.day, from: today)
        todayMonthNumber = calendar.component(.month, from: today)
        todayYearNumber = calendar.component(.year, from: today)
    
        monthPointer = Variable<Date>(today.startOfMonth())
        
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
                self.loadMonth()
            })
            .addDisposableTo(disposeBag)
        
//        addAMonth()
//        substractAMonth()
        
//        loadMonth()
    }
    
    func loadMonth() {
        days.value.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays()
    }
    
    func addDaysBeforeMonthFirstDay() {
        let weekday = Calendar.current.component(.weekday, from: monthPointer.value)
        //sunday = 1
        var europeanWeekday = weekday - 1
        if europeanWeekday == 0 {
            europeanWeekday = 7
        }
        
        for _ in 1..<europeanWeekday {
            let day = Day(number: 0)
            days.value.append(day)
        }
    }
    
    func loadMonthDays() {
        let endDate = monthPointer.value.endOfMonth()
        let calendar = Calendar.current
        let endDayNumber  = calendar.component(.day, from: endDate)
        let monthNumber = calendar.component(.month, from: monthPointer.value)
        let yearNumber = calendar.component(.year, from: monthPointer.value)
        
        for i in 1...endDayNumber {
            var day = Day(number: i)
            day.isToday = (i == todayDayNumber && monthNumber == todayMonthNumber && yearNumber == todayYearNumber)
            days.value.append(day)
        }
        
    }
    
    func addAMonth() {
        monthPointer.value = monthPointer.value.nextMonth()
    }
    
    func substractAMonth() {
        monthPointer.value = monthPointer.value.previousMonth()
    }
}
