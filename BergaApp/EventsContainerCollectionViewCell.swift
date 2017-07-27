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
import RxDataSources

class EventsContainerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var disposeBag: DisposeBag? = DisposeBag()
    var eventCellWidth: Double?
    let cellDataSource = RxCollectionViewSectionedReloadDataSource<CalendarEventSection>()
    
    override func prepareForReuse() {
        disposeBag = nil
        disposeBag = DisposeBag()
    }
    
    func setCellWidth() {
        let width = (collectionView.frame.size.width - (30) * 2) / 2
        eventCellWidth = Double(width)
        collectionView.delegate = self
    }
}

extension EventsContainerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: eventCellWidth!, height: 275)
    }
}
