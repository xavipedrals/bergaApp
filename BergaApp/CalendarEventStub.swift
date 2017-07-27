//
//  CalendarEventStub.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class CalendarEventStub {
    
    func getStub() -> [CalendarEvent] {
        
        let event1 = CalendarEvent(
            date: Date(),
            name: "Festa major d'Avià",
            type: .townFest,
            townAddress: "Avià",
            imgUrl: "https://cdn-az.allevents.in/banners/259c33ece099d7fe80134f093a1a98b2"
        )
        
        let event2 = CalendarEvent(
            date: Commons.getDateFromString(date: "05-31-2017", format: "MM-dd-yyyy")!,
            name: "Fira de Santa Tecla",
            type: .fair,
            townAddress: "Berga",
            imgUrl: "http://www.ajberga.cat/perfil/berga/recursos/arxiuimatges/grans/sta_tecla.jpg"
        )
        
        let event3 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-14-2017", format: "MM-dd-yyyy")!,
            name: "La Patum de Berga",
            type: .townFest,
            townAddress: "Berga",
            imgUrl: "http://www.ajberga.cat/perfil/berga/recursos/arxiuimatges/grans/cartell_actesweb.jpg"
        )
        
        let event4 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-15-2017", format: "MM-dd-yyyy")!,
            name: "La Patum de Berga",
            type: .townFest,
            townAddress: "Berga",
            imgUrl: "http://www.ajberga.cat/perfil/berga/recursos/arxiuimatges/grans/cartell_actesweb.jpg"
        )
        
        let event11 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-16-2017", format: "MM-dd-yyyy")!,
            name: "Patum Infantil",
            type: .townFest,
            townAddress: "Berga",
            imgUrl: "http://www.lapatum.cat/fotos/cartell_patum_infantil.jpg"
        )
        
        let event12 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-16-2017", format: "MM-dd-yyyy")!,
            name: "Barraques",
            type: .townFest,
            townAddress: "Berga"
        )
        
        let event5 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-16-2017", format: "MM-dd-yyyy")!,
            name: "La Patum de Berga",
            type: .townFest,
            townAddress: "Berga",
            imgUrl: "http://www.ajberga.cat/perfil/berga/recursos/arxiuimatges/grans/cartell_actesweb.jpg"
        )
        
        let event6 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-17-2017", format: "MM-dd-yyyy")!,
            name: "La Patum de Berga",
            type: .townFest,
            townAddress: "Berga"
        )
        
        let event7 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-18-2017", format: "MM-dd-yyyy")!,
            name: "La Patum de Berga",
            type: .townFest,
            townAddress: "Berga"
        )
        
        let event8 = CalendarEvent(
            date: Commons.getDateFromString(date: "05-23-2017", format: "MM-dd-yyyy")!,
            name: "Event de prova amb un nom molt i molt llarg",
            type: .fair,
            townAddress: "Gironella"
        )
        
        let event9 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-24-2017", format: "MM-dd-yyyy")!,
            name: "Sant Joan",
            type: .fair,
            townAddress: "Gironella"
        )
        
        let event10 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-24-2017", format: "MM-dd-yyyy")!,
            name: "Cursa popular",
            type: .sport,
            townAddress: "Vilada"
        )
        
        let event13 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-16-2017", format: "MM-dd-yyyy")!,
            name: "Excursió amb bicicleta",
            type: .sport,
            townAddress: "Borredà",
            imgUrl: "https://www.runningcampus.com/media/items/medium/e8243-CARTELL-JV_2016.jpeg"
        )
        
        let event14 = CalendarEvent(
            date: Commons.getDateFromString(date: "05-31-2017", format: "MM-dd-yyyy")!,
            name: "Caminada popular",
            type: .sport,
            townAddress: "Sant Llorenç de Morunys",
            imgUrl: "https://www.runningcampus.com/media/items/medium/e8243-CARTELL-JV_2016.jpeg"
        )
        
        let event15 = CalendarEvent(
            date: Commons.getDateFromString(date: "06-5-2017", format: "MM-dd-yyyy")!,
            name: "Torneig de bàsquet 3x3",
            type: .sport,
            townAddress: "Olvan",
            imgUrl: "http://xarxanet.org/sites/default/files/basquet_3x3_agost.jpg"
        )
        
        let event16 = CalendarEvent(
            date: Date(),
            name: "Torneig de futbol sala",
            type: .sport,
            townAddress: "Bagà",
            imgUrl: "http://www.olesademontserrat.cat/media/site1/cache/images/cartell-color-torneig-futbol-sala-femeni-2.png"
        )
        
        return [event1, event2, event3, event4, event5, event6, event7, event8, event9, event10, event11, event12, event13, event14, event15, event16]
    }
}
