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
    var postalCode: String?
    var street: String?
    
    init(town: String) {
        self.town = town
    }
    
    init(town: String, postalCode: String, street: String) {
        self.town = town
        self.postalCode = postalCode
        self.street = street
    }
    
    func getStringified() -> String {
        var address = ""

        if let street = self.street {
            address = street + ", "
        }
        if let postalCode = self.postalCode {
            address = address + postalCode + " "
        }
        address = address + town
        return address
    }
}

extension Address: Equatable {
    static func ==(lhs: Address, rhs: Address) -> Bool {
        return lhs.town == rhs.town && lhs.street == rhs.street
    }
}
