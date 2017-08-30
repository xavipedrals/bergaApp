//
//  ShopNotificationsViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift

class ShopNotificationsViewModel {

    let notifications = Variable<[ShopNotification]>([])
    
    init() {
        getNotifications()
    }
    
    func getNotifications() {
        notifications.value = ShopNotificationsStub.get()
    }
    
}
