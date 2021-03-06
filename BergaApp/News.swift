//
//  News.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import SwiftyJSON

struct News: ParseableObject {
    
    var title: String
    var subtitle: String
    var url: String
    var provider: NewsProvider
    var imageUrl: String
    var timestamp: Date
    
    init(from json: JSON) {
        title = json["title"].stringValue
        subtitle = json["description"].stringValue
        url = json["url"].stringValue
        imageUrl = json["imageUrl"].stringValue
        timestamp = Date(date: json["timestamp"].stringValue, format: CustomDateFormat.standard)
        provider = NewsProvider(string: json["provider"].stringValue)
    }
    
    init(title: String, subtitle: String, url: String, provider: NewsProvider, imageUrl: String, timestamp: Date) {
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.provider = provider
        self.imageUrl = imageUrl
        self.timestamp = timestamp
    }
    
    func getStringTime() -> String {
        return timestamp.getString(format: CustomDateFormat.newsOutput)
    }
    
}
