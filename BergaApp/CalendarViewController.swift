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
    
    var cellWidth: Double?
    let dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>()
//    let dataSource = RxCollectionViewSectionedAnimatedDataSource<CalendarSection>()

    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    var selectedIndex: IndexPath?
    var selectedEvent: CalendarEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle()
        configureCollectionView()
        configureSwipe()
    }
    
    func setNavigationTitle() {
        let titleLabel = UILabel()

        calendarViewModel.monthYearStr.asObservable()
            .map({ monthYear -> NSAttributedString in
                self.getMonthYearAttributedString(monthYear)
            })
            .subscribe(onNext: { attributedTitle in
                titleLabel.attributedText = attributedTitle
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            })
            .addDisposableTo(disposeBag)
    }
    
    func getMonthYearAttributedString(_ monthYear: String) -> NSAttributedString {
        let monthYearArr = monthYear.components(separatedBy: " ")
        let attributedTitle = NSMutableAttributedString(string: monthYear)
        let monthRange = NSMakeRange(0, monthYearArr[0].length)
        attributedTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold), range: monthRange)
        
        let yearRange = NSMakeRange(monthYearArr[0].length + 1, monthYearArr[1].length)
        attributedTitle.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightLight), range: yearRange)
        return attributedTitle
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
        
        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            if kind == UICollectionElementKindSectionFooter {
                let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarFooter", for: indexPath)
                return header
            }
            else {
                let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "separatorHeader", for: indexPath)
                return header
            }
        }
        
        calendarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 0 {
                    let cell = self.calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
                    cell.setSelected()
                    self.selectedIndex = indexPath
                    self.calendarViewModel.updateEventsSection(dayAt: indexPath)
                }
                else {
                    if let event = self.calendarViewModel.getEvent(at: indexPath) {
                        self.selectedEvent = event
                        self.performSegue(withIdentifier: "goToEventDetail", sender: nil)
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetail" {
            let eventDetail = segue.destination as! EventDetailViewController
            eventDetail.event = self.selectedEvent
        }
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
            return getDayCellSize()
        }
        return getEventCellSize()
    }
    
    func getDayCellSize() -> CGSize {
        return CGSize(width: cellWidth!, height: cellWidth!)
    }
    
    func getEventCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width - 20
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == self.calendarViewModel.EVENTS_SECTION {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: 5)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == self.calendarViewModel.CALENDAR_SECTION && self.calendarViewModel.sections.value[self.calendarViewModel.EVENTS_SECTION].items.count == 0 {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: 165)
        }
        return CGSize(width: 0, height: 0)
    }
}
