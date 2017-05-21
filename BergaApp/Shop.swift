//
//  Shop.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxDataSources

struct ShopSection {
    var header: String
    var items: [Item]
    
    var identity: String {
        return header
    }
}

extension ShopSection: SectionModelType{
    typealias Item = Shop
    
    init(original: ShopSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class Shop {
    
    //add var id
    var name: String
    var isPromoted: Bool
    
    init(name: String, isPromoted: Bool = false) {
        self.name = name
        self.isPromoted = isPromoted
    }
}


