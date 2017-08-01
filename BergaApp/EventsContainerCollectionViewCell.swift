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
    
    func setupCell() {
        setCellWidth()
        setupCollectionCells()
        setupCollectionHeaderAndFooter()
    }
    
    private func setCellWidth() {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - (30) * 2) / 2
        eventCellWidth = Double(width)
        collectionView.delegate = self
    }
    
    private func setupCollectionCells() {
        cellDataSource.configureCell = { (ds, cv, indexPath, item) in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
            cell.initCell(from: item)
            return cell
        }
    }
    
    private func setupCollectionHeaderAndFooter() {
        cellDataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            if kind == UICollectionElementKindSectionHeader {
                let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "eventsHeader", for: indexPath)
                return header
            }
            else if kind == UICollectionElementKindSectionFooter {
                let footer = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "eventsFooter", for: indexPath)
                return footer
            }
            return UICollectionReusableView()
        }
    }
}

extension EventsContainerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let eventCellHeight = eventCellWidth! * 1.34 + 110
        return CGSize(width: eventCellWidth!, height: eventCellHeight)
    }
}
