//
//  DayCellView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 20/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class DayCellView: UIView {
    
    @IBOutlet weak var backgroundView: CustomView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dotView: CustomView!
    @IBOutlet weak var dayButton: UIButton!
    
    var isToday: Bool?
    var isEmpty: Bool?
    
    func initView(from day: Day) {
        configureEmpty(day.number)
        isToday = day.isToday
        backgroundView.backgroundColor = isToday! ? UIColor(r: 255, g: 52, b: 43) : UIColor.clear
        numberLabel.textColor = isToday! ? UIColor.white : UIColor.black
        numberLabel.text = String(day.number)
        dotView.isHidden = (!day.hasEvents || day.isToday)
    }
    
    func configureEmpty(_ num: Int) {
        isEmpty = num == 0
        numberLabel.isHidden = isEmpty!
        backgroundView.isHidden = isEmpty!
        dayButton.isEnabled = !isEmpty!
    }
    
    func setSelected() {
        if (isToday != nil && !isToday!) {
            backgroundView.backgroundColor = Colors.red
            numberLabel.textColor = UIColor.white
        }
    }
    
    func setUnselected() {
        if (isToday != nil && !isToday!) {
            backgroundView.backgroundColor = UIColor.clear
            numberLabel.textColor = UIColor.black
        }
    }
    
    //MARK: Default implementation
    
    var contentView : UIView?
    
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
}
