//
//  CalendarFooterCollectionReusableView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class CalendarFooterCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var backgroundImageView: CorneredImageView!
    
    func setBackground(url: String) {
        backgroundImageView.kf.setImage(with: URL(string: url))
    }
}
