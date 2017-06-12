//
//  CalendarFooterCollectionReusableView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class CalendarFooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var topView: ShadowView!
    @IBOutlet weak var cardView: CardView!
    
    func setNormal() {
        topView.isHidden = false
        cardView.isHidden = false
    }
    
    func setFiller() {
        topView.isHidden = true
        cardView.isHidden = true
    }
        
}
