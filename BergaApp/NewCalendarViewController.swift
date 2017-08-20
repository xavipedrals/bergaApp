//
//  NewCalendarViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 20/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewCalendarViewController: UIViewController {

    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet var dayRowViews: [DayRowView]!
    @IBOutlet weak var calendarHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var calendarContainer: UIStackView!
    
    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    var daysInRows = [[Day]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMonthLabel()
        setupCalendar()
        configureSwipes()
    }
    
    func setupMonthLabel() {
        calendarViewModel.monthYearStr.asObservable()
            .bind(to: monthYearLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    func setupCalendar() {
        calendarViewModel.days.asObservable()
            .subscribe(onNext: { days in
                self.setup(days: days)
                self.initRowViews()
                self.setCalendarHeight()
            })
            .addDisposableTo(disposeBag)
    }
    
    func initMatrix() {
        daysInRows = [[Day]]()
        for _ in 1 ... 6 {
            daysInRows.append([])
        }
    }
    
    func setup(days: [Day]) {
        initMatrix()
        for (i, day) in days.enumerated() {
            let row = i / 7
            daysInRows[row].append(day)
        }
        addMonthEmptyDays()
    }
    
    func addMonthEmptyDays() {
        for i in 0 ..< daysInRows.count {
            if daysInRows[i].count > 0 {
                while daysInRows[i].count < 7 {
                    daysInRows[i].append(Day(number: 0, month: 1))
                }
            }
        }
    }
    
    func initRowViews() {
        for (i, rowView) in dayRowViews.enumerated() {
            if daysInRows[i].count > 0 {
                rowView.initView(days: daysInRows[i])
                rowView.isHidden = false
            }
            else {
                rowView.isHidden = true
            }
        }
    }
    
    func setCalendarHeight() {
        calendarHeightConstrint.constant = getCalendarHeight()
        self.view.layoutIfNeeded()
    }
    
    func getCalendarHeight() -> CGFloat {
        var height = CGFloat(0)
        var rowHeight = (UIScreen.main.bounds.width - 28) / 7
        rowHeight = ceil(rowHeight)
        for row in daysInRows {
            if row.count > 0 {
                height += rowHeight
            }
        }
        return height
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
//                self.selectedIndex = nil
            })
            .addDisposableTo(disposeBag)
        
        calendarContainer.addGestureRecognizer(swipeGesture)
    }
    
}
