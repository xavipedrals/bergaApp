//
//  ShopNotification.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

struct ShopNotification {
    
    var title: String
    var body: String
    var date: Date
    
    init(title: String, body: String, date: Date) {
        self.title = title
        self.body = body
        self.date = date
    }
}
