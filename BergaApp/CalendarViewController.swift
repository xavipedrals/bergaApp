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

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    var cellWidth: Double?
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
        
        calendarCollectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
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
        return CGSize(width: cellWidth!, height: cellWidth!)
    }
}
