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
    @IBOutlet weak var monthYearLabel: UILabel!
    
    var dayCellWidth: Double?
    let dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>()
//    let dataSource = RxCollectionViewSectionedAnimatedDataSource<CalendarSection>()

    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    var selectedIndex: IndexPath?
    var selectedEvent: CalendarEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendarTitle()
        configureCollectionView()
        configureSwipes()
    }
    
    func setCalendarTitle() {
        calendarViewModel.monthYearStr.asObservable()
            .map({ monthYear -> NSAttributedString in
                self.getMonthYearAttributedString(monthYear)
            })
            .subscribe(onNext: { attributedTitle in
                self.monthYearLabel.attributedText = attributedTitle
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
                
            case .calendarEvent(let event):
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
                cell.initCell(from: event)
                return cell
            }
        }
    }
    
    func configureHeaderAndFooter() {
        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            if kind == UICollectionElementKindSectionFooter {
                if indexPath.section == 0 {
                    let footer = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarFooter", for: indexPath) as! CalendarFooterCollectionReusableView
                    footer.setNormal()
                    return footer
                }
                else {
                    let footer = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarFooter", for: indexPath) as! CalendarFooterCollectionReusableView
                    footer.setFiller()
                    return footer
                }
            }
            else {
                let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "separatorHeader", for: indexPath)
                return header
            }
        }
    }
    
    func configureItemSelection() {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
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
        return getEventCellSize()
    }
    
    func getDayCellSize() -> CGSize {
        return CGSize(width: dayCellWidth!, height: dayCellWidth!)
    }
    
    func getEventCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == calendarViewModel.EVENTS_SECTION && calendarViewModel.eventsCount > 0 {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: 15)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        if section == calendarViewModel.CALENDAR_SECTION && calendarViewModel.eventsCount == 0 {
            let height = getFooterHeightWithEvents()
            return CGSize(width: width, height: height < 215 ? 215 : height)
        }
        else if section == calendarViewModel.EVENTS_SECTION && calendarViewModel.eventsCount > 0 {
            let height = getFooterHeightWithEvents()
            return CGSize(width: width, height: height < 0 ? 0 : height)
        }
        return CGSize(width: 0, height: 0)
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
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
