//
//  ShopPhotoCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 25/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class ShopPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopImageView: CorneredImageView!
    
    func initCell(url: String) {
        shopImageView.kf.setImage(with: URL(string: url))
    }
    
}
