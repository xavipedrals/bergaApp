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
        data.value = NewsStub().getStub()
    }
    
}
