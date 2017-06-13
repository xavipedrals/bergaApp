//
//  EventOrganizer.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

struct EventOrganizer {
    
    var name: String
    var twitterUrl: String?
    var facebookUrl: String?
    var instagramUrl: String?
    var webUrl: String?
    var imgUrl: String?
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, twitter: String? = nil, facebook: String? = nil, instagram: String? = nil, web: String? = nil, image: String? = nil) {
        self.name = name
        self.twitterUrl = twitter
        self.facebookUrl = facebook
        self.instagramUrl = instagram
        self.webUrl = web
        self.imgUrl = image
    }
    
}
