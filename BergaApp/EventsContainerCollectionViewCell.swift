//
//  EventsContainerCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventsContainerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag: DisposeBag? = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = nil
        disposeBag = DisposeBag()
    }
}
