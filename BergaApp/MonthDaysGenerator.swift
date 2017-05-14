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
    
    init(){
        self.monthPointer = Date()
        self.days = []
        let today = Date()
        let calendar = Calendar.current
        todayDayNumber = calendar.component(.day, from: today)
        todayMonthNumber = calendar.component(.month, from: today)
        todayYearNumber = calendar.component(.year, from: today)
    }
    
    func generate(from: Date) -> [Day] {
        monthPointer = from
        days.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays(markedDays: [])
        return self.days
    }
    
    func generate(from: Date, markedDays: [Int]) -> [Day] {
        monthPointer = from
        days.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays(markedDays: markedDays)
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
    
    func loadMonthDays(markedDays: [Int]) {
        let endDate = monthPointer.endOfMonth()
        let calendar = Calendar.current
        let endDayNumber  = calendar.component(.day, from: endDate)
        let monthNumber = calendar.component(.month, from: monthPointer)
        let yearNumber = calendar.component(.year, from: monthPointer)
        
        for i in 1...endDayNumber {
            var day = Day(number: i)
            if markedDays.contains(i) {
                day.hasEvents = true
            }
            day.isToday = (i == todayDayNumber && monthNumber == todayMonthNumber && yearNumber == todayYearNumber)
            days.append(day)
        }
    }
    
    func getDay(number: Int) -> Date? {
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: monthPointer)
        dateComponents.month = calendar.component(.month, from: monthPointer)
        dateComponents.day = number
        
        let someDateTime = calendar.date(from: dateComponents)
        return someDateTime
    }
}
