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
    var dayCellWidth: Double?
    
    override func prepareForReuse() {
        disposeBag = nil
        disposeBag = DisposeBag()
    }
    
    func setCellWidth() {
        let width = (collectionView.frame.size.width - (10 + 10) * 2) / 2
        dayCellWidth = Double(width)
        collectionView.delegate = self
    }
}

extension EventsContainerCollectionViewCell: UICollectionViewDelegateFlowLayout {
//    override func viewDidLayoutSubviews() {
//        setCellWidth()
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dayCellWidth!, height: 275)
    }
}
