//
//  CalendarDaysGenerator.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class MonthDaysGenerator {
    
    var monthPointer: Date
    private var days: [Day]
    private var todayDayNumber: Int
    private var todayMonthNumber: Int
    private var todayYearNumber: Int
    
    init(from: Date){
        self.monthPointer = from
        self.days = []
        let today = Date()
        let calendar = Calendar.current
        todayDayNumber = calendar.component(.day, from: today)
        todayMonthNumber = calendar.component(.month, from: today)
        todayYearNumber = calendar.component(.year, from: today)
    }
    
    func generate() -> [Day] {
        days.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays()
        return self.days
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
            days.append(day)
        }
    }
    
    func loadMonthDays() {
        let endDate = monthPointer.endOfMonth()
        let calendar = Calendar.current
        let endDayNumber  = calendar.component(.day, from: endDate)
        let monthNumber = calendar.component(.month, from: monthPointer)
        let yearNumber = calendar.component(.year, from: monthPointer)
        
        for i in 1...endDayNumber {
            var day = Day(number: i)
            day.isToday = (i == todayDayNumber && monthNumber == todayMonthNumber && yearNumber == todayYearNumber)
            days.append(day)
        }
        
    }
}
