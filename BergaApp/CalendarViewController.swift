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
    
    var dayCellWidth: Double?
    let dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>()
//    let dataSource = RxCollectionViewSectionedAnimatedDataSource<CalendarSection>()

    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    var selectedIndex: IndexPath?
    var selectedEvent: CalendarEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureSwipes()
    }
    
    func configureCollectionView() {
        bindDataSource()
        configureCells()
        configureHeaderAndFooter()
        configureItemSelection()

        calendarCollectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func bindDataSource() {
        calendarViewModel.sections.asObservable()
            .bind(to: calendarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func configureCells() {
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
                
            case .calendarEvent(_):
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "eventsContainerCell", for: indexPath) as! EventsContainerCollectionViewCell
                
                cell.setCellWidth()
                
                self.calendarViewModel.eventsSection.asObservable()
                    .bind(to: cell.collectionView.rx.items(dataSource: cell.cellDataSource))
                    .disposed(by: cell.disposeBag!)
                
                cell.cellDataSource.configureCell = { (ds, cv, indexPath, item) in
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
                    cell.initCell(from: item)
                    return cell
                }
                
                cell.cellDataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
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
                
                return cell
            }
        }
    }
    
    func configureHeaderAndFooter() {
        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            if kind == UICollectionElementKindSectionFooter {
                let footer = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarFooter", for: indexPath) as! CalendarFooterCollectionReusableView
                footer.setBackground(url: "https://source.unsplash.com/500x400/?nature")
                return footer
            }
            else {
                let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "monthHeader", for: indexPath) as! MonthHeaderCollectionReusableView
                header.initCell(text: self.calendarViewModel.monthYearStr.value)
                return header
            }
        }
    }
    
    func configureItemSelection() {
        calendarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 0 {
                    self.manageDayCellClick(indexPath: indexPath)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func manageDayCellClick(indexPath: IndexPath) {
        let cell = calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        cell.setSelected()
        selectedIndex = indexPath
        calendarViewModel.updateEventsSection(dayAt: indexPath)
    }
    
    func configureItemDeselection() {
        calendarCollectionView.rx.itemDeselected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 0 {
                    let cell = self.calendarCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
                    cell.setUnselected()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func configureSwipes() {
        configureSwipe(right: true)
        configureSwipe(right: false)
    }
    
    func configureSwipe(right: Bool) {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = right ? .right : .left
        swipeGesture.rx.event
            .subscribe(onNext: { _ in
                right
                    ? self.calendarViewModel.substractAMonth()
                    : self.calendarViewModel.addAMonth()
                self.selectedIndex = nil
            })
            .addDisposableTo(disposeBag)
        
        calendarCollectionView.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func goPreviousMonth(_ sender: Any) {
        self.calendarViewModel.substractAMonth()
        self.selectedIndex = nil
    }
    
    @IBAction func goNextMonth(_ sender: Any) {
        self.calendarViewModel.addAMonth()
        self.selectedIndex = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetail" {
            let eventDetail = segue.destination as! EventDetailViewController
            eventDetail.event = self.selectedEvent
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func setCellWidth() {
        let width = (calendarCollectionView.frame.size.width - (10 + 10) * 2) / 7
        dayCellWidth = Double(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == calendarViewModel.CALENDAR_SECTION {
            return getDayCellSize()
        }
        return getEventsContainerCellSize()
    }
    
    func getDayCellSize() -> CGSize {
        return CGSize(width: dayCellWidth!, height: dayCellWidth!)
    }
    
    func getEventsContainerCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == calendarViewModel.EVENTS_CONTAINER_SECTION {
            return CGSize(width: 0, height: 0)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        if section == calendarViewModel.CALENDAR_SECTION && calendarViewModel.eventsCount == 0 {
            return CGSize(width: width, height: width * 65 / 100)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func getFooterHeightWithoutEvents() -> CGFloat {
        let footerHeight = getFooterHeight()
        let eventsHeaderHeight = 15
        let eventsHeight = self.calendarViewModel.eventsCount * 85
        let newHeight = footerHeight - CGFloat(eventsHeight + eventsHeaderHeight)
        return newHeight
    }
    
    func getFooterHeightWithEvents() -> CGFloat {
        let footerHeight = getFooterHeight()
        let eventsHeaderHeight = 15
        let eventsHeight = self.calendarViewModel.eventsCount * 85
        let newHeight = footerHeight - CGFloat(eventsHeight + eventsHeaderHeight)
        return newHeight
    }
    
    func getFooterHeight() -> CGFloat {
        var dayRows = Double(self.calendarViewModel.daysCount) / 7.0
        dayRows.round(.up)
        let rowsHeight = dayRows * dayCellWidth!
        let headerHeight = 66.0
        let weekHeader = 40.0
        let tabBarHeight = 49.0
        let screenHeight = UIScreen.main.bounds.height
        let footerHeight = screenHeight - CGFloat(headerHeight + weekHeader + rowsHeight + tabBarHeight)
        return footerHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == calendarViewModel.CALENDAR_SECTION {
            return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
