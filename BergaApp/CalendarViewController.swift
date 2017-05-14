//
//  CalendarViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var cellWidth: Double?
    let dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>()
    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarViewModel.days.asObservable()
            .bind(to: calendarCollectionView.rx.items(cellIdentifier: "dayCell", cellType: DayCollectionViewCell.self)) {
                _, day, cell in
                cell.initFrom(day: day)
            }
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let cell = self.calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
                cell.setSelected()
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.rx.itemDeselected
            .subscribe(onNext: { indexPath in
                let cell = self.calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
                cell.setUnselected()
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        calendarViewModel.monthStr.asObservable()
            .bind(to: monthLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        calendarViewModel.yearStr.asObservable()
            .bind(to: yearLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = .left
        swipeLeft.rx.event
            .subscribe(onNext: { _ in
                self.calendarViewModel.addAMonth()
            })
            .addDisposableTo(disposeBag)
        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight.rx.event
            .subscribe(onNext: { _ in
                self.calendarViewModel.substractAMonth()
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.addGestureRecognizer(swipeLeft)
        calendarCollectionView.addGestureRecognizer(swipeRight)

        
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        self.addGestureRecognizer(swipeLeft)
//        
//        // Add Right Swipe Gesture
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft()))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        self.addGestureRecognizer(swipeRight)
    }
    
//    func swipeRight() {
//        calendarViewModel.substractAMonth()
//    }
//    
//    func swipeLeft() {
//        calendarViewModel.addAMonth()
//    }
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func setCellWidth() {
        let flow: UICollectionViewFlowLayout = calendarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (calendarCollectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) * 2) / 7
        cellWidth = Double(width)
    }

}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: cellWidth!)
    }
}
