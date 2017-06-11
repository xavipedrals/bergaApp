//
//  WeatherColors.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 11/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class WeatherColors {
    
    static let sunnyBackground = UIColor(r: 39, g: 222, b: 232)
    static let riseBackground = UIColor(r: 61, g: 225, b: 176)
    static let fallBackground = UIColor(r: 238, g: 173, b: 94)
    static let cloudBackground = UIColor(r: 125, g: 158, b: 167)
    static let rainBackground = UIColor(r: 75, g: 125, b: 119)
    static let nightBackground = UIColor(r: 62, g: 81, b: 79)
    
    static func getColor(from weather: Weather) -> UIColor {
        switch weather.type {
        case .sunny:
            return sunnyBackground
        case .cloudy:
            return cloudBackground
        case .rain:
            return rainBackground
        case .night:
            return nightBackground
        case .rise:
            return riseBackground
        case .fall:
            return fallBackground
        }
    }
    
}
