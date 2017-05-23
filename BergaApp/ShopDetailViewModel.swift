//
//  ShopDetailViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 23/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift

class ShopDetailViewModel {
    
    let shopDetail: Variable<ShopDetail>
    
    init(shop: Shop) {
        shopDetail = Variable(ShopDetailStub.getStub(shop: shop))
    }
    
}
