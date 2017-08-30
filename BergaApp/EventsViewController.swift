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
import Kingfisher

class EventsViewController: UIViewController {

    @IBOutlet weak var collectionView: CenteredCollectionView!
    @IBOutlet weak var noEventsView: UIView!
    @IBOutlet weak var noEventsImageView: CorneredImageView!
    
    let events = Variable<[CalendarEvent]>([])
    var centeredScrollManager = CenteredScrollManager()
    let disposeBag = DisposeBag()
    var selectedIndex: IndexPath?
    var selectedEvent: CalendarEvent?
    
    let itemSpacing = CGFloat(15)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoEventsView()
        setupCollectionView()
    }
    
    func setupNoEventsView() {
        noEventsImageView.kf.setImage(with: URL(string: "https://source.unsplash.com/500x400/?nature"))
        events.asObservable()
            .map({ $0.count != 0 })
            .bind(to: noEventsView.rx.isHidden)
            .addDisposableTo(disposeBag)
    }
    
    func setupCollectionView() {
        setupCollectionLayout()
        setupCollectionViewCells()
        observeCollectionClicks()
        setCollectionDelegate()
    }
    
    func setupCollectionLayout() {
        setCellSize()
        collectionView.setup(itemSpacing: itemSpacing)
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
        setCellSize()
    }
    
    func setCellSize() {
        let screenWidth = UIScreen.main.bounds.width
        cellWidth = (screenWidth - (30) * 2) / 2
        cellHeight = cellWidth * 1.34 + 110
        centeredScrollManager.set(pageWidth: cellWidth * 2 + itemSpacing * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellHeight = cellWidth * 1.34 + 110
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension EventsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = centeredScrollManager.getNextItemPoint(velocity: velocity, targetContentOffset: targetContentOffset, collectionContentSize: collectionView!.contentSize.width)
        targetContentOffset.pointee = point
    }
}
