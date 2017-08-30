//
//  NotificationActionView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 30/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class NotificationActionView: CustomReusableView {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var backgroundView: CustomView!
    
    var activated: Bool!
    
    func set(activated: Bool) {
        self.activated = activated
        setState()
    }
    
    private func setState() {
        if activated {
            backgroundView.backgroundColor = Colors.dimGreen
            bodyLabel.text = "Notificacions push ON"
        }
        else {
            backgroundView.backgroundColor = Colors.lightRed
            bodyLabel.text = "Notificacions push OFF"
        }
    }
    
    @IBAction func notificationPressed(_ sender: Any) {
        activated = !activated
        setState()
    }
    
    override func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
