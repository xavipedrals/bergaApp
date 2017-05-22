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
    
    let searchString = Variable<String>("")
    let sections = Variable<[ShopSection]>([
        ShopSection(header: "Patrocinadors", items: []),
        ShopSection(header: "No Patrocinadors", items: [])
        ])
    
    var fullSections = [ShopSection]()
    
    let PROMOTED_SECTION = 0
    let NON_PROMOTED_SECTION = 1
    let disposeBag = DisposeBag()
    
    
    init() {
        getShops()
        
        searchString.asObservable()
            .filter({ $0.characters.count > 0 })
            .map({ $0.lowercased() })
            .subscribe(onNext: { search in
                let promotedSection = self.fullSections[self.PROMOTED_SECTION]
                let filteredPromotedSectionItems = promotedSection.items.filter({ $0.name.lowercased().contains(search) })
                self.sections.value[self.PROMOTED_SECTION] = ShopSection(original: self.sections.value[self.PROMOTED_SECTION], items: filteredPromotedSectionItems)
                
                let nonPromotedSection = self.fullSections[self.NON_PROMOTED_SECTION]
                let filteredNonPromotedSectionItems = nonPromotedSection.items.filter({ $0.name.lowercased().contains(search) })
                self.sections.value[self.NON_PROMOTED_SECTION] = ShopSection(original: self.sections.value[self.NON_PROMOTED_SECTION], items: filteredNonPromotedSectionItems)
            })
            .addDisposableTo(disposeBag)
        
        searchString.asObservable()
            .filter({ $0.characters.count == 0 })
            .subscribe(onNext: { _ in
                self.sections.value[self.PROMOTED_SECTION] = ShopSection(original: self.sections.value[self.PROMOTED_SECTION], items: self.fullSections[self.PROMOTED_SECTION].items)
                
                self.sections.value[self.NON_PROMOTED_SECTION] = ShopSection(original: self.sections.value[self.NON_PROMOTED_SECTION], items: self.fullSections[self.NON_PROMOTED_SECTION].items)
            })
            .addDisposableTo(disposeBag)
        
        }
    
    func getShops() {
        let shops = ShopStub().getStub()
        let promotedShops = shops.filter({ $0.isPromoted })
        let nonPromotedShops = shops.filter({ !$0.isPromoted })
        
        let promotedSection = ShopSection(original: sections.value[PROMOTED_SECTION], items: promotedShops)
        let nonPromotedSection = ShopSection(original: sections.value[NON_PROMOTED_SECTION], items: nonPromotedShops)
        sections.value[PROMOTED_SECTION] = promotedSection
        sections.value[NON_PROMOTED_SECTION] = nonPromotedSection
        fullSections = sections.value
    }
    
}
