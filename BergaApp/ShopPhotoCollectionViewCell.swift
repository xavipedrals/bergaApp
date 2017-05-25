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
    
    @IBOutlet weak var imageView: UIImageView!
    
    func initCell(url: String) {
        imageView.kf.setImage(with: URL(string: url))
    }
    
}
