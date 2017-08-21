//
//  EventsViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 21/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let events = Variable<[CalendarEvent]>([])
    let disposeBag = DisposeBag()
    var selectedIndex: IndexPath?
    var selectedEvent: CalendarEvent?
    
    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(15)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    var pageWidth = CGFloat(0)
    var currentItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    func setupCollectionView() {
        setupCollectionLayout()
        setupCollectionViewCells()
        observeCollectionClicks()
        setCollectionDelegate()
    }
    
    func setupCollectionLayout() {
        setCollectionItemSize()
        let layout = getCollectionLayout()
        collectionView!.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func setCollectionItemSize() {
        pageWidth =  UIScreen.main.bounds.width - 40
        let screenWidth = UIScreen.main.bounds.width
        cellWidth = (screenWidth - (30) * 2) / 2
        cellHeight = cellWidth * 1.34 + 110
    }
    
    func getCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: pageWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: 20, height: 0)
        layout.footerReferenceSize = CGSize(width: 20, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func setupCollectionViewCells() {
        events.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "eventCell", cellType: EventCollectionViewCell.self)) { _, event, cell in
                cell.initCell(from: event)
            }
            .addDisposableTo(disposeBag)
    }
    
    func observeCollectionClicks() {
        collectionView.rx.modelSelected(CalendarEvent.self)
            .subscribe(onNext: { event in
                self.selectedEvent = event
                self.performSegue(withIdentifier: "goToEventDetail", sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    func setCollectionDelegate() {
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetail" {
            let eventDetail = segue.destination as! EventDetailViewController
            eventDetail.event = self.selectedEvent
        }
    }

}

extension EventsViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func setCellWidth() {
        let screenWidth = UIScreen.main.bounds.width
        cellWidth = (screenWidth - (30) * 2) / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellHeight = cellWidth * 1.34 + 110
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension EventsViewController: UIScrollViewDelegate {
    
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
