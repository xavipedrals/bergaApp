//
//  SocialBarView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 01/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class SocialBarView: UIView {
    
    @IBOutlet weak var twitterBackground: SocialButtonBackground!
    @IBOutlet weak var facebookBackground: SocialButtonBackground!
    @IBOutlet weak var instagramBackground: SocialButtonBackground!
    @IBOutlet weak var webBackground: SocialButtonBackground!
    
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    
    func setUrls(twitter: String?, facebook: String?, instagram: String?, web: String?) {
        twitterBackground.configure(url: twitter)
        facebookBackground.configure(url: facebook)
        instagramBackground.configure(url: instagram)
        webBackground.configure(url: web)
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
