//
//  News.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
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

struct News {
    
    var title: String
    var subtitle: String
    var url: String
    var provider: NewsProvider
    var imageUrl: String
    var timestamp: Date
    
}
