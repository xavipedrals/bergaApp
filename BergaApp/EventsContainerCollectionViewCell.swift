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
    
    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(15)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    var currentItem = 0
    
    override func prepareForReuse() {
        disposeBag = nil
        disposeBag = DisposeBag()
//        setupCollectionLayout()
    }
    
    func setupCell() {
        setCellWidth()
//        setupCollectionLayout()
        setupCollectionCells()
        setupCollectionHeaderAndFooter()
    }
    
    private func setCellWidth() {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - (30) * 2) / 2
        eventCellWidth = Double(width)
        collectionView.delegate = self
    }
    
    private func setupCollectionLayout() {
        setCollectionItemSize()
        let layout = getCollectionLayout()
        collectionView!.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    private func setCollectionItemSize() {
        cellWidth =  UIScreen.main.bounds.width - 40
        cellHeight = CGFloat(eventCellWidth! * 1.34 + Double(110))
//        let eventCellHeight = eventCellWidth! * 1.34 + 110
    }
    
    private func getCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.itemSize = CGSize(width: CGFloat(eventCellWidth!), height: cellHeight)

        layout.headerReferenceSize = CGSize(width: 20, height: 0)
        layout.footerReferenceSize = CGSize(width: 20, height: 0)
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        return layout
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

extension EventsContainerCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(cellWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width)
        
        var newPage = Float(currentItem)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        }
        else {
            newPage = Float(velocity.x > 0 ? currentItem + 1 : currentItem - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        currentItem = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    
}
