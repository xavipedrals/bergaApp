//
//  SocialBarView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 01/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class SocialBarView: CustomReusableView {
    
    @IBOutlet weak var twitterBackground: SocialButtonBackground!
    @IBOutlet weak var facebookBackground: SocialButtonBackground!
    @IBOutlet weak var instagramBackground: SocialButtonBackground!
    @IBOutlet weak var webBackground: SocialButtonBackground!
    
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    
    let disposeBag = DisposeBag()
    var twitterUrl: String?
    var facebookUrl: String?
    var instagramUrl: String?
    var webUrl: String?
    
    func setUrls(twitter: String?, facebook: String?, instagram: String?, web: String?) {
        twitterUrl = twitter
        facebookUrl = facebook
        instagramUrl = instagram
        webUrl = web
        
        twitterBackground.configure(url: twitter)
        facebookBackground.configure(url: facebook)
        instagramBackground.configure(url: instagram)
        webBackground.configure(url: web)
        observeSocialButtons()
    }
    
    func observeSocialButtons() {
        twitterButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.twitterUrl)
            })
            .addDisposableTo(disposeBag)
        
        facebookButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.facebookUrl)
            })
            .addDisposableTo(disposeBag)
        
        instagramButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.instagramUrl)
            })
            .addDisposableTo(disposeBag)
        
        webButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.webUrl)
            })
            .addDisposableTo(disposeBag)
    }
    
    func open(url: String?) {
        if let url = url {
            if let url = URL(string: url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
