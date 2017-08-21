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
    @IBOutlet weak var eventsContainerHeight: NSLayoutConstraint!
    
    let calendarViewModel = CalendarViewModel()
    let disposeBag = DisposeBag()
    var daysInRows = [[Day]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMonthLabel()
        setupCalendar()
        configureSwipes()
        observeSelectedDay()
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
        eventsContainerHeight.constant = getEventsHeight()
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
    
    func getEventsHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - (30) * 2) / 2
        return cellWidth * 1.34 + 125
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
            })
            .addDisposableTo(disposeBag)
        
        calendarContainer.addGestureRecognizer(swipeGesture)
    }
    
    func observeSelectedDay() {
        for dayRowView in dayRowViews {
            dayRowView.selectedDay.asObservable()
                .subscribe(onNext: { num in
                    self.cleanAllSelectedDays()
                    self.selectDay(number: num)
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    func cleanAllSelectedDays() {
        for dayRowView in dayRowViews {
            dayRowView.cleanSelectedDays()
        }
    }
    
    func selectDay(number: Int) {
        let index = calendarViewModel.days.value.index(where: { $0.number == number })
        if let index = index {
            let row = index / 7
            let column = index % 7
            dayRowViews[row].selectDay(at: column)
        }
        calendarViewModel.updateEvents(dayNumber: number)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededEvents" {
            let vc = segue.destination as! EventsViewController
            calendarViewModel.events.asObservable()
                .bind(to: vc.events)
                .addDisposableTo(disposeBag)
        }
    }
    
}
