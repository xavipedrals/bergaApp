//
//  ArrayParser.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ParseableObject {
    init(from: JSON)
}

class ArrayParser<T: ParseableObject> {
    
    static func parseJSONToArray(_ json: [JSON]) -> [T] {
        var result = [T]()
        
        for item in json {
            let element = T(from: item)
            result.append(element)
        }
        
        return result
    }
    
}
