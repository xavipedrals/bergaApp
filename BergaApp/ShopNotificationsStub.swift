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
        
        for i in 1...5 {
            let notification1 = ShopNotification(
                title: "Test " + String(i),
                body: "Això és una notificaió de prova")
            
            notifications.append(notification1)
        }
        
        return notifications
    }
}
