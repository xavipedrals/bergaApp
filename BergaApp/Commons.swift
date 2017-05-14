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
        let comp: DateComponents = Calendar.current.dateComponents([.day], from: self)
        var comps2 = DateComponents()
        comps2.day = -(comp.day! - 1)
        let startOfMonth = Calendar.current.date(byAdding: comps2, to: self)!
        return startOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func nextMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    func previousMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
    }
}
