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

extension CalendarModelType: Equatable {
    static func ==(lhs: CalendarModelType, rhs: CalendarModelType) -> Bool {
        switch (lhs, rhs) {
        case (let .day(dl), let .day(dr)):
            return dl.number == dr.number && dl.hasEvents == dr.hasEvents && dl.isToday == dr.isToday
            
        case (let .calendarEvent(el), let .calendarEvent(er)):
            return el.date == er.date && el.name == er.name && el.type == er.type && el.address == er.address
            
        default:
            return false
        }
    }
}

extension CalendarModelType: IdentifiableType {
    typealias Identity = String
    
    public var identity: Identity {
        switch self {
        case .day(let day):
            return String(day.number)
            
        case .calendarEvent(let event):
            return event.name
        }
    }
}

struct CalendarSection {
    var header: String
    var items: [Item]
    
    var identity: String {
        return header
    }
}

extension CalendarSection: AnimatableSectionModelType {
    typealias Item = CalendarModelType
    
    init(original: CalendarSection, items: [Item]) {
        self = original
        self.items = items
    }
}
