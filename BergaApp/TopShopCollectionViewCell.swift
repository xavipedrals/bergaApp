//
//  TopShopCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 17/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class TopShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var shopImageView: CorneredImageView!
    
    func initCell(from shop: Shop) {
        nameLabel.text = shop.name
        let tags = shop.tags!.joined(separator: ", ")
        tagsLabel.text = tags
        if let imgUrls = shop.photosUrls {
            shopImageView.kf.setImage(with: URL(string: imgUrls[0]))
        }
    }
}
