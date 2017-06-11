//
//  WeatherView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 11/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit


class WeatherView: UIView {

    var contentView : UIView?
    @IBOutlet weak var tempreatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var backgroundView: ShadowView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func set(weather: Weather) {
        backgroundView.backgroundColor = WeatherColors.getColor(from: weather)
        tempreatureLabel.text = String(weather.celciusGrades) + "º"
        weatherImg.image = UIImage(named: weather.imgName)
        weatherLabel.text = weather.name
    }

}
