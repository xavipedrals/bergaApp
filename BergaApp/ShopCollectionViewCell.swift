//
//  ShopTableViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    func initCell(from: Shop) {
        nameLabel.text = from.name
    }

}
