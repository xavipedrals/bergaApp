//
//  Weather.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 11/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

enum WeatherType {
    case sunny
    case cloudy
    case rain
    case rise
    case fall
    case night
}


struct Weather {
    
    var celciusGrades: Int
    var type: WeatherType
    var name: String {
        get {
            switch self.type {
            case .sunny, .rise, .fall:
                return "Assolellat"
            case .cloudy:
                return "Núvol"
            case .rain:
                return "Pluja"
            case .night:
                return "Nit"
            }
        }
    }
    var imgName: String {
        get {
            switch self.type {
            case .sunny:
                return "sun"
            case .cloudy:
                return "cloudy"
            case .rain:
                return "rain"
            case .night:
                return "night"
            case .rise:
                return "sunrise"
            case .fall:
                return "sunset"
            }
        }
    }
    
    init(celciusGrades: Int, type: WeatherType) {
        self.celciusGrades = celciusGrades
        self.type = type
    }
    
}
