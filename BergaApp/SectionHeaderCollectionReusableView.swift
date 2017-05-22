//
//  SectionHeaderCollectionReusableView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 22/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func initHeader(title: String) {
        self.titleLabel.text = title
    }
}
