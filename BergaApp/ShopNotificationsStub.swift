//
//  ShopNotificationsStub.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class ShopNotificationsStub {
    
    static func get() -> [ShopNotification] {
        var notifications = [ShopNotification]()
        
        let notification1 = ShopNotification(
            title: "Rebaixes 50%",
            body: "Durant tota aquesta setmana tenim tots els nostres productes rebaixats a meitat de preu, no t'ho perdis!",
            date: Date())
        
        let notification2 = ShopNotification(
            title: "Gangues al carrer",
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum maximus sagittis. Sed posuere et lorem ut fermentum. Phasellus nec molestie nulla.",
            date: Date(date: "01/09/2017", format: .stub))
        
        let notification3 = ShopNotification(
            title: "Vacances",
            body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum maximus sagittis. Sed posuere et lorem ut fermentum. Phasellus nec molestie nulla.",
            date: Date(date: "23/08/2017", format: .stub))
        
        notifications = [notification1, notification2, notification3]
        
        
        return notifications
    }
}
