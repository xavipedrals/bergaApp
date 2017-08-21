//
//  NewsTitleTableViewCell.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var bigImageView: CorneredImageView!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    func initCell(from news: News) {
        self.selectionStyle = .none
        newsTitleLabel.text = news.title
        bigImageView.kf.setImage(with: URL(string: news.imageUrl))
        providerImageView.image = UIImage(named: news.provider.imageName)
        providerLabel.text = news.provider.name
        timeLabel.text = news.getStringTime().capitalized
    }

}
