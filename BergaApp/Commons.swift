//
//  Commons.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class Commons {
    
    static func getStringFromDate(date: Date, format: String) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        let dateStr = dateFormat.string(from: date)
        return dateStr
    }
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
