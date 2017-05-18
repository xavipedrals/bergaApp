//
//  Shop.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

struct Shop {
    
    var name: String
    var description: String?
    var phone: Int?
    var schedule: String?
    var coordinates: Coordinates?
    var url: String?
    var photosUrls: [String]?
    
    init(name: String) {
        self.name = name
    }

}
