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
    var monthPointer: Date
    
    init() {
        let calendar = Calendar.current
        todayDayNumber = calendar.component(.day, from: today)
        todayMonthNumber = calendar.component(.month, from: today)
        
        let monthYear = Commons.getStringFromDate(date: today, format: "MMM yyyy")
        let monthYearArr = monthYear.components(separatedBy: " ")
        monthStr.value = monthYearArr[0].uppercased()
        yearStr.value = monthYearArr[1]
        
        
        monthPointer = today.startOfMonth()
        
        print(Date())
        print(Date().startOfMonth())
        print(Date().endOfMonth())
        
//        addAMonth()
//        substractAMonth()
        
        loadMonth()
    }
    
    func loadMonth() {
        days.value.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays()
    }
    
    func addDaysBeforeMonthFirstDay() {
        let weekday = Calendar.current.component(.weekday, from: monthPointer)
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
        let endDate = monthPointer.endOfMonth()
        let calendar = Calendar.current
        let endDayNumber  = calendar.component(.day, from: endDate)
        let monthNumber = calendar.component(.month, from: monthPointer)
        
        for i in 1...endDayNumber {
            var day = Day(number: i)
            day.isToday = (i == todayDayNumber && monthNumber == self.todayMonthNumber)
            days.value.append(day)
        }
        
    }
    
    func addAMonth() {
        monthPointer = monthPointer.nextMonth()
    }
    
    func substractAMonth() {
        monthPointer = monthPointer.previousMonth()
    }
}
