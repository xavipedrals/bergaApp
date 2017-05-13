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
    
    
    func initCell(from: News) {
        titleLabel.text = from.title
        subtitleLabel.text = from.subtitle
        newsImageView.kf.setImage(with: URL(string: from.imageUrl)!)
        providerImageView.kf.setImage(with: URL(string: from.providerImgUrl)!)
        providerName.text = from.provider
    }

}
