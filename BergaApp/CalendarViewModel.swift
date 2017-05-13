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
    var todayNumber: Int
    
    init() {
        let today = Date()
        let calendar = Calendar.current
        todayNumber = calendar.component(.day, from: today)
        let monthYear = Commons.getStringFromDate(date: today, format: "MMM yyyy")
        let monthYearArr = monthYear.components(separatedBy: " ")
        monthStr.value = monthYearArr[0].uppercased()
        yearStr.value = monthYearArr[1]
        
        
        
        loadMonth()
    }
    
    func loadMonth() {
        days.value.removeAll()
        let weekday = Calendar.current.component(.weekday, from: Date())
        //monday = 7
        var europeanWeekday = weekday + 1
        if europeanWeekday == 8 {
            europeanWeekday = 1
        }
        
        for _ in 1..<europeanWeekday {
            let day = Day(number: 0)
            days.value.append(day)
        }
        
        for i in 1...31 {
            var day = Day(number: i)
            day.isToday = (i == todayNumber)
            days.value.append(day)
        }
    }
}
