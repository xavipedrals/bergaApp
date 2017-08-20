//
//  DayRowView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 20/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class DayRowView: UIView {
    
    @IBOutlet var dayCellViews: [DayCellView]!
    
    //dayViews
    let selectedDay = Variable<Int>(-1)
    
    func initView(days: [Day]) {
        guard days.count == 7 && dayCellViews.count == 7 else {
            print("Incorrect number of days or views to init days row")
            return
        }
        for (i, dayView) in dayCellViews.enumerated() {
            dayView.initView(from: days[i])
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
