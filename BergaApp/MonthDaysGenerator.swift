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
    var daysInRows: [[Day]]
    private var days: [Day]
    private var todayDayNumber: Int
    private var todayMonthNumber: Int
    private var todayYearNumber: Int
    
    init(){
        self.monthPointer = Date()
        self.days = []
        self.daysInRows = []
        let today = Date()
        let calendar = Calendar.current
        todayDayNumber = calendar.component(.day, from: today)
        todayMonthNumber = calendar.component(.month, from: today)
        todayYearNumber = calendar.component(.year, from: today)
    }
    
    func generate(from: Date, markedDays: [Int]) -> [Day] {
        monthPointer = from
        days.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays(markedDays: markedDays)
        return self.days
    }
    
    func generateMatrix(date: Date, markedDays: [Int]) -> [[Day]] {
        monthPointer = date
        days.removeAll()
        addDaysBeforeMonthFirstDay()
        loadMonthDays(markedDays: markedDays)
        initMatrix(days: self.days)
        return self.daysInRows
    }
    
    func addDaysBeforeMonthFirstDay() {
        let weekday = Calendar.current.component(.weekday, from: monthPointer)
        //sunday = 1
        var europeanWeekday = weekday - 1
        if europeanWeekday == 0 {
            europeanWeekday = 7
        }
        let monthNumber = Calendar.current.component(.month, from: monthPointer)
        for _ in 1..<europeanWeekday {
            let day = Day(number: 0, month: monthNumber)
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
            var day = Day(number: i, month: monthNumber)
            if markedDays.contains(i) {
                day.hasEvents = true
            }
            day.isToday = (i == todayDayNumber && monthNumber == todayMonthNumber && yearNumber == todayYearNumber)
            days.append(day)
        }
    }
    
    func getDate(number: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: monthPointer)
        dateComponents.month = calendar.component(.month, from: monthPointer)
        dateComponents.day = number
        
        let someDateTime = calendar.date(from: dateComponents)
        return someDateTime
    }
    
    private func initMatrix(days: [Day]) {
        daysInRows = []
        for (i, day) in days.enumerated() {
            let row = i / 7
            if row >= daysInRows.count {
                daysInRows.append([])
            }
            daysInRows[row].append(day)
        }
        addMonthEmptyDays()
    }
    
    private func addMonthEmptyDays() {
        for i in 0 ..< daysInRows.count {
            while daysInRows[i].count > 0 && daysInRows[i].count < 7 {
                daysInRows[i].append(Day(number: 0, month: 1))
            }
        }
    }
    
    func getIndexFor(dayNumber: Int) -> Int? {
        return days.index(where: { $0.number == dayNumber })
    }
}
