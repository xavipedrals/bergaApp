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
    
    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(15)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    var currentItem = 0
    
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
                return self.getDayCell(indexPath: indexPath, day: day)
                
            case .calendarEvent(_):
                return self.setupEventCell(cv: cv, indexPath: indexPath)
            }
        }
    }
    
    func getDayCell(indexPath: IndexPath, day: Day) -> DayCollectionViewCell {
        let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        cell.initFrom(day: day)
        if let selectedIndex = self.selectedIndex {
            if selectedIndex == indexPath {
                cell.setSelected()
            }
        }
        return cell
    }
    
    func setupEventCell(cv: UICollectionView, indexPath: IndexPath) -> EventsContainerCollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "eventsContainerCell", for: indexPath) as! EventsContainerCollectionViewCell
        
        self.calendarViewModel.eventsSection.asObservable()
            .bind(to: cell.collectionView.rx.items(dataSource: cell.cellDataSource))
            .disposed(by: cell.disposeBag!)
        
        cell.setupCell()
        
        cell.collectionView.rx.modelSelected(CalendarEvent.self)
            .subscribe(onNext: { event in
                self.selectedEvent = event
                self.performSegue(withIdentifier: "goToEventDetail", sender: nil)
            })
            .addDisposableTo(cell.disposeBag!)
        
        return cell
    }
    
    func configureHeaderAndFooter() {
        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            if kind == UICollectionElementKindSectionFooter {
                return self.getCalendarFooter(indexPath: indexPath)
            }
            else {
                return self.getCalendarHeader(indexPath: indexPath)
            }
        }
    }
    
    func getCalendarFooter(indexPath: IndexPath) -> CalendarFooterCollectionReusableView {
        let footer = calendarCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "calendarFooter", for: indexPath) as! CalendarFooterCollectionReusableView
        footer.setBackground(url: "https://source.unsplash.com/500x400/?nature")
        return footer
    }
    
    func getCalendarHeader(indexPath: IndexPath) -> MonthHeaderCollectionReusableView {
        let header = calendarCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "monthHeader", for: indexPath) as! MonthHeaderCollectionReusableView
        header.initCell(text: self.calendarViewModel.monthYearStr.value)
        return header
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
        let eventWidth = (width - (30) * 2) / 2
        let eventHeight = eventWidth * 1.34 + 100 + 20
        return CGSize(width: width, height: eventHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == calendarViewModel.EVENTS_CONTAINER_SECTION {
            return CGSize(width: 0, height: 0)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        if section == calendarViewModel.CALENDAR_SECTION && calendarViewModel.eventsCount == 0 {
            return CGSize(width: width, height: width * 65 / 100 + 20)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == calendarViewModel.CALENDAR_SECTION {
            return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension CalendarViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(cellWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(calendarCollectionView!.contentSize.width)
        
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
