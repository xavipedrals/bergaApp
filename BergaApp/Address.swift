//
//  Address.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 27/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class Address {
    var town: String
    var street: String?
    
    init(town: String) {
        self.town = town
    }
}

extension Address: Equatable {
    static func ==(lhs: Address, rhs: Address) -> Bool {
        return lhs.town == rhs.town && lhs.street == rhs.street
    }
}
