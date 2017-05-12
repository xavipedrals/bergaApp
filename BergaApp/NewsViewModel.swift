//
//  NewsViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift

class NewsViewModel {
    
    let data = Variable<[News]>([])
    
    init() {
        getNews()
    }
    
    func getNews() {
        let new1 = News()
        let new2 = News()
        let new3 = News()
        data.value.append(new1)
        data.value.append(new2)
        data.value.append(new3)

    }
    
}
