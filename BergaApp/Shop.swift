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
    //http://beta.json-generator.com/api/json/get/VkzGTe0Mm
    //add var id
    var name: String
    var isPromoted: Bool
    var description: String
    var phone: Int?
    var schedule: String?
    var url: String?
    var photosUrls: [String]?
    var address: String?
    var tags: [String]?
    
    init(name: String, description: String, isPromoted: Bool = false) {
        self.name = name
        self.description = description
        self.isPromoted = isPromoted
    }
}


