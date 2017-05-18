//
//  ShopListViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift

class ShopListViewModel {
    
    let shops = Variable<[Shop]>([])
    
    init() {
        getShops()
    }
    
    func getShops() {
        shops.value = ShopStub().getStub()
    }
    
}
