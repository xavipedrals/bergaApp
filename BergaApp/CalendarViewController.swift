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
    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    var selectedIndex: IndexPath?
    var selectedEvent: CalendarEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVisuals()
        configureCollectionView()
        configureSwipe()
    }
    
    func initVisuals() {
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
        
        calendarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 0 {
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
            return CGSize(width: cellWidth!, height: cellWidth!)
        }
        let width = UIScreen.main.bounds.width - 20
        return CGSize(width: width, height: 50)
    }
}
