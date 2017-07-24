//
//  MonthHeaderCollectionReusableView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 22/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MonthHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    func initCell(text: String) {
        monthLabel.text = text
    }
}
