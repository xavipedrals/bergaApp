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
    
    let sections = Variable<[ShopSection]>([
        ShopSection(header: "Patrocinadors", items: []),
        ShopSection(header: "No Patrocinadors", items: [])
        ])
    
    let PROMOTED_SECTION = 0
    let NON_PROMOTED_SECTION = 1
    
    init() {
        getShops()
    }
    
    func getShops() {
        let shops = ShopStub().getStub()
        let promotedShops = shops.filter({ $0.isPromoted })
        let nonPromotedShops = shops.filter({ !$0.isPromoted })
        
        let promotedSection = ShopSection(original: sections.value[PROMOTED_SECTION], items: promotedShops)
        let nonPromotedSection = ShopSection(original: sections.value[NON_PROMOTED_SECTION], items: nonPromotedShops)
        sections.value[PROMOTED_SECTION] = promotedSection
        sections.value[NON_PROMOTED_SECTION] = nonPromotedSection
    }
    
}
