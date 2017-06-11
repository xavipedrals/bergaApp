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
        
        setNavigationTitle()
        configureCollectionView()
        configureSwipe()
    }
    
    func setNavigationTitle() {

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
                let footer = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarFooter", for: indexPath)
                return footer
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
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func setCellWidth() {
        let width = (calendarCollectionView.frame.size.width - (10 + 10) * 2) / 7
        dayCellWidth = Double(width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
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
        return CGSize(width: dayCellWidth!, height: dayCellWidth!)
    }
    
    func getEventCellSize() -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == self.calendarViewModel.EVENTS_SECTION {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: 15)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == self.calendarViewModel.CALENDAR_SECTION && self.calendarViewModel.sections.value[self.calendarViewModel.EVENTS_SECTION].items.count == 0 {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width, height: 200)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == calendarViewModel.CALENDAR_SECTION {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
