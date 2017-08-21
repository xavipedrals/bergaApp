//
//  NewsProvider.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

enum NewsProviderType {
    case nacioDigital
    case regio7
    case aquiBergueda
    case panxing
    case ara
}

struct NewsProvider {
    var name: String
    var imageName: String
    
    
    init(string: String) {
        var type = NewsProviderType.nacioDigital
        switch string {
        case "Nació Digital":
            type = NewsProviderType.nacioDigital
            break
        case "Regió7":
            type = NewsProviderType.regio7
            break
        case "Aquí Berguedà":
            type = NewsProviderType.aquiBergueda
            break
        case "Pànxing":
            type = NewsProviderType.panxing
            break
        case "Ara":
            type = NewsProviderType.ara
            break
        default:
            type = NewsProviderType.nacioDigital
            break
        }
        self.init(type)
    }
    
    init(_ provider: NewsProviderType) {
        var name = ""
        var imageName = ""
        switch provider {
        case .nacioDigital:
            name = "Nació Digital"
            imageName = "nacioDigital"
            break
        case .regio7:
            name = "Regió7"
            imageName = "regio7"
            break
        case .aquiBergueda:
            name = "Aquí Berguedà"
            imageName = "aquiBergueda"
            break
        case .panxing:
            name = "Pànxing"
            imageName = "panxing"
            break
        case .ara:
            name = "Ara.cat"
            imageName = "ara"
            break
        }
        self.name = name
        self.imageName = imageName
    }
}
