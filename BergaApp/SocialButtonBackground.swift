//
//  SocialButtonBackground.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 30/07/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class SocialButtonBackground: CustomView {
    
    func configure(url: String?) {
        self.backgroundColor = url != nil
            ? Colors.dimGreen
            : UIColor.lightGray
    }
}
