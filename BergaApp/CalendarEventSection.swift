//
//  CalendarEventSection.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 26/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxDataSources

struct CalendarEventSection {
    var header: String
    var items: [Item]
    
    var identity: String {
        return header
    }
}

extension CalendarEventSection: SectionModelType {
    typealias Item = CalendarEvent
    
    init(original: CalendarEventSection, items: [Item]) {
        self = original
        self.items = items
    }
}

//TODO: This can be improved
//extension CalendarEvent: Equatable {
//    static func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
//        return lhs.address == rhs.address
//            && lhs.date == rhs.date
//            && lhs.description == rhs.description
//            && lhs.name == rhs.name
//    }
//}

//extension CalendarEvent: IdentifiableType {
//    typealias Identity = String
//    
//    public var identity: Identity {
//        return self.name
//    }
//}
