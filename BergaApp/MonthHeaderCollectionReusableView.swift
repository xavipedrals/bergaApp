//
//  MonthHeaderCollectionReusableView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 22/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MonthHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var monthLabel: UILabel!
    let text = Variable<String>("Mes 2017")
    var disposeBag: DisposeBag? = DisposeBag()
    
    func initCell(text: String) {
        monthLabel.text = text
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = nil
//        disposeBag = DisposeBag()
//        text.asObservable()
//            .bind(to: monthLabel.rx.text)
//            .addDisposableTo(disposeBag!)
//    }
    
}
