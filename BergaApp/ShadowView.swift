//
//  ShadowView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 07/06/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 3, height: 3)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
