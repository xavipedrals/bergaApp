//
//  TextSectionView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 01/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class TextSectionView: CustomReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func set(title: String, body: String) {
        titleLabel.text = title
        let text = Commons.getAttributedLineSpaceText(body, lineSpacing: 2)
        bodyLabel.attributedText = text
    }
    
    override func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
