//
//  ShopDetail.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 21/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class ShopDetail: Shop {
    
    var description: String?
    var phone: Int?
    var schedule: String?
    var url: String?
    var photosUrls: [String]?
    var address: String?
    
    override init(name: String, isPromoted: Bool = false) {
        super.init(name: name, isPromoted: isPromoted)
    }
    
    init(from shop: Shop) {
        super.init(name: shop.name, isPromoted: shop.isPromoted)
    }
}
