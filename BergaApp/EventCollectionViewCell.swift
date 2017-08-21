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
    @IBOutlet weak var posterImageView: CorneredImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    
    func initCell(from event: CalendarEvent) {
        nameLabel.text = event.name
//        posterImageView.setupShadow()
        if let imageUrl = event.imgUrl {
            posterImageView.kf.setImage(with: URL(string: imageUrl))
            imageContainer.dropShadow()
        }
        placeLabel.text = event.address.town
    }
}
