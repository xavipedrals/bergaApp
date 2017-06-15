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
    let sections = Variable<[NotificationSection]>([
        NotificationSection(isNewest: true, items: []),
        NotificationSection(isNewest: false, items: []),
        ])
    
    var newNotificationsCount: Int {
        get {
            return sections.value[0].items.count - 1
        }
    }
    
    init() {
        getNotifications()
    }
    
    func getNotifications() {
        let notifications = ShopNotificationsStub.get()
        var notificationModels = [NotificationModel]()
        notificationModels.append(NotificationModel.header(true))
        
        for notification in notifications {
            notificationModels.append(NotificationModel.shopNotification(notification))
        }
        
        sections.value[0] = NotificationSection(original: sections.value[0], items: notificationModels)
    }
    
}
