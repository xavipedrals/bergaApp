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
    var selectedIndex: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVisuals()
        configureCollectionView()
        configureSwipe()
    }
    
    func initVisuals() {
        calendarViewModel.monthStr.asObservable()
            .bind(to: monthLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        calendarViewModel.yearStr.asObservable()
            .bind(to: yearLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    func configureCollectionView() {
        calendarViewModel.sections.asObservable()
            .bind(to: calendarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        dataSource.configureCell = { (ds, cv, indexPath, item) in
            switch item {
            case .day(let day):
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
                cell.initFrom(day: day)
                if let selectedIndex = self.selectedIndex {
                    if selectedIndex == indexPath {
                        cell.setSelected()
                    }
                }
                return cell
                
            case .calendarEvent(let event):
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
                cell.initCell(from: event)
                return cell
            }
        }
        
        calendarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 0 {
//                    let cell = self.calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
//                    cell.setSelected()
                    self.selectedIndex = indexPath
                    self.calendarViewModel.updateEventsSection(dayAt: indexPath.row)
                }
                else {
                    //Show a map?
                }
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.rx.itemDeselected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 0 {
                    let cell = self.calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
                    cell.setUnselected()
                }
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func configureSwipe() {
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = .left
        swipeLeft.rx.event
            .subscribe(onNext: { _ in
                self.calendarViewModel.addAMonth()
                self.selectedIndex = nil
            })
            .addDisposableTo(disposeBag)
        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = .right
        swipeRight.rx.event
            .subscribe(onNext: { _ in
                self.calendarViewModel.substractAMonth()
                self.selectedIndex = nil
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.addGestureRecognizer(swipeLeft)
        calendarCollectionView.addGestureRecognizer(swipeRight)
    }
    
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
        if indexPath.section == 0 {
            return CGSize(width: cellWidth!, height: cellWidth!)
        }
        let width = UIScreen.main.bounds.width - 20
        return CGSize(width: width, height: 50)
    }
}
