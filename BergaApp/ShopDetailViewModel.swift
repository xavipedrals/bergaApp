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
    
    let shop: Variable<Shop>
    let photosUrl = Variable<[String]>([])
    
    init(shop: Shop) {
        self.shop = Variable(shop)
        
        if let photos = self.shop.value.photosUrls {
            photosUrl.value = photos
        }
    }
    
}
