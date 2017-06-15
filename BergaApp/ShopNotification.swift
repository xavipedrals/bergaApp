//
//  ShopNotification.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxDataSources

struct NotificationSection {
    var isNewest: Bool
    var items: [NotificationModel]
}

extension NotificationSection: SectionModelType {
    typealias Item = NotificationModel
    
    init(original: NotificationSection, items: [Item]) {
        self = original
        self.items = items
    }
}

enum NotificationModel {
    case shopNotification(ShopNotification)
    case header(Bool)
}

struct ShopNotification {
    
    var title: String
    var body: String
    var date: Date
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
        self.date = Date()
    }
}
