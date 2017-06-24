//
//  NewsTableViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var shareButton: UIButton!
//    @IBOutlet weak var wrapper: CustomView!
    
    
    func initCell(from: News) {
        titleLabel.text = from.title
        subtitleLabel.text = from.subtitle
        if let imageUrl = URL(string: from.imageUrl) {
            newsImageView.kf.setImage(with: imageUrl)
        }
        providerImageView.image = UIImage(named: from.provider.imageName)
        providerName.text = from.provider.name + " - " + from.getStringTime()
//        wrapper.dropShadow()
    }

}
