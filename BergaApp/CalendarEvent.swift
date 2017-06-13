//
//  CalendarEvent.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

enum CalendarEventType: String {
    case sport = "running"
    case townFest = "majorFest"
    case fair = "carousel"
}

struct CalendarEvent {
    
    var date: Date
    var name: String
    var description: String
    var price: String?
    var imgUrl: String?
    var organizer: EventOrganizer
    var type: CalendarEventType
    var typeName: String {
        get {
            switch type {
            case .sport:
                return "Esport"
            case .townFest:
                return "Festa Major"
            case .fair:
                return "Fira"
            }
        }
    }
    var address: Address
    
    init(date: Date, name: String, type: CalendarEventType, townAddress: String) {
        self.date = date
        self.name = name
        self.type = type
        self.address = Address(town: townAddress)
        self.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor tortor vitae urna"
        self.imgUrl = "https://scontent.fmad3-3.fna.fbcdn.net/v/t1.0-9/13394139_1134146096646399_918156780983641389_n.jpg?oh=16e6052a81459c5f216305470d002d0a&oe=59DFCA3D"
        self.organizer = EventOrganizer(name: "Ajuntament de Berga", twitter: "", facebook: "")
    }
}
