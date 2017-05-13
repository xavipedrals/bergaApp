//
//  CalendarViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel {
    
    let days = Variable<[Int]>([])
    
    init() {
        loadMonth()
    }
    
    func loadMonth() {
        days.value.removeAll()
        for i in 1...31 {
            days.value.append(i)
        }
    }
}
