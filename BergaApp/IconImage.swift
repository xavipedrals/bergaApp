//
//  CustomImage.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class IconImage: UIImageView {
    
    @IBInspectable var iconTint: UIColor? {
        didSet {
            if iconTint != nil {
                image = image!.withRenderingMode(.alwaysTemplate)
                tintColor = iconTint!
            }
        }
    }

    
}
