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
    @IBOutlet weak var sectionIcon: UIImageView!
    
    func initHeader(title: String) {
        titleLabel.text = title
        let imageName = title == "Patrocinadors" ? "favorite" : "favorite-outline"
        sectionIcon.image = UIImage(named: imageName)
    }
}
