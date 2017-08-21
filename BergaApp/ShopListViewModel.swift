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
    var topShops = Variable<[Shop]>([])
    
    let PROMOTED_SECTION = 0
    let NON_PROMOTED_SECTION = 1
    let disposeBag = DisposeBag()
    
    
    init() {
        getShops()
        
        searchString.asObservable()
            .filter({ $0.characters.count > 0 })
            .map({ $0.lowercased() })
            .subscribe(onNext: { search in
                let promotedShops = self.getFilteredShops(sectionIndex: self.PROMOTED_SECTION, search: search)
                self.updateSection(index: self.PROMOTED_SECTION, shops: promotedShops)
                
                let nonPromotedShops = self.getFilteredShops(sectionIndex: self.NON_PROMOTED_SECTION, search: search)
                self.updateSection(index: self.NON_PROMOTED_SECTION, shops: nonPromotedShops)
            })
            .addDisposableTo(disposeBag)
        
        searchString.asObservable()
            .filter({ $0.characters.count == 0 })
            .subscribe(onNext: { _ in
                self.updateSection(index: self.PROMOTED_SECTION, shops: self.fullSections[self.PROMOTED_SECTION].items)
                self.updateSection(index: self.NON_PROMOTED_SECTION, shops: self.fullSections[self.NON_PROMOTED_SECTION].items)
            })
            .addDisposableTo(disposeBag)
        
    }
    
    func getShops() {
        let shops = ShopStub().getStub()
        let promotedShops = shops.filter({ $0.isPromoted })
        let nonPromotedShops = shops.filter({ !$0.isPromoted })
        topShops.value = promotedShops
        
        let promotedSection = ShopSection(original: sections.value[PROMOTED_SECTION], items: promotedShops)
        let nonPromotedSection = ShopSection(original: sections.value[NON_PROMOTED_SECTION], items: nonPromotedShops)
        sections.value[PROMOTED_SECTION] = promotedSection
        sections.value[NON_PROMOTED_SECTION] = nonPromotedSection
        fullSections = sections.value
    }
    
    private func getFilteredShops(sectionIndex: Int, search: String) -> [Shop] {
        let fullSection = fullSections[sectionIndex]
        let filteredSectionShops = fullSection.items.filter({ $0.name.lowercased().contains(search) })
        return filteredSectionShops

    }
    
    private func updateSection(index: Int, shops: [Shop]) {
        sections.value[index] = ShopSection(original: sections.value[index], items: shops)
    }
}
