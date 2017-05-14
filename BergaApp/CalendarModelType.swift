//
//  CalendarModelType.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxDataSources

enum CalendarModelType {
    case day(Day)
    case calendarEvent(CalendarEvent)
}

//extension CalendarModelType: Equatable {
//    static func ==(lhs: CalendarModelType, rhs: CalendarModelType) -> Bool {
//        return false
//    }
//}
//
//extension CalendarModelType: IdentifiableType {
//    typealias Identity = String
//    
//    public var identity: Identity { return self.identity }
//}

struct CalendarSection {
    var header: String
    var items: [Item]
    
    var identity: String {
        return header
    }
}

extension CalendarSection: SectionModelType{
    typealias Item = CalendarModelType
    
    init(original: CalendarSection, items: [Item]) {
        self = original
        self.items = items
    }
}
