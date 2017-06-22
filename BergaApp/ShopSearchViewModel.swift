//
//  ShopSearchViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 21/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift

class ShopSearchViewModel {
    
    let searchString = Variable<String>("")
    let sections = Variable<[ShopSection]>([
        ShopSection(header: "Tags", items: []),
        ShopSection(header: "Comerços", items: [])
        ])
    
    var fullSections = [ShopSection]()
    
    let TAG_SECTION = 0
    let SHOP_SECTION = 1
    let disposeBag = DisposeBag()
    
    init() {
        
        searchString.asObservable()
            .subscribe(onNext: { search in
                //perform a Search
                
            })
            .addDisposableTo(disposeBag)
    }
}
