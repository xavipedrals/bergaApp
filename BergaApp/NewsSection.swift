//
//  NewsSection.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxDataSources

class NewsSection: SectionModelType {
    
    typealias Item = News
    var name: String
    var items: [News]
    
    public required init(original: NewsSection, items: [Item]) {
        self.name = original.name
        self.items = items
    }
    
    init(name: String, items: [News]) {
        self.name = name
        self.items = items
    }
}
