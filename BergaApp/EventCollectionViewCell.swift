//
//  EventCollectionViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 14/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    func initCell(from event: CalendarEvent) {
        nameLabel.text = event.name
        if let imageUrl = event.imgUrl {
            posterImageView.kf.setImage(with: URL(string: imageUrl))
        }
        placeLabel.text = event.address.town
    }
}
