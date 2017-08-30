//
//  PhoneView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 30/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

@IBDesignable
class PhoneView: CustomReusableView {
    
    @IBOutlet weak var phoneLabel: UILabel!
    var phoneNumber: Int?
    
    func set(phone: Int?) {
        phoneNumber = phone
        phoneLabel.text = phone != nil
            ? "Trucar al " + getPhoneString(phone!)
            : "Telèfon no disponible"
    }
    
    func getPhoneString(_ number: Int) -> String {
        var phoneStr = String(number)
        if phoneStr.length >= 9 {
            phoneStr.insert(" ", at: phoneStr.index(phoneStr.startIndex, offsetBy: 2))
            phoneStr.insert(" ", at: phoneStr.index(phoneStr.startIndex, offsetBy: 6))
            phoneStr.insert(" ", at: phoneStr.index(phoneStr.startIndex, offsetBy: 9))
        }
        return phoneStr
        
    }
    
    @IBAction func callPressed(_ sender: Any) {
        if let phoneNumber = phoneNumber {
            callNumber(String(phoneNumber))
        }
    }
    
    private func callNumber(_ phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.openURL(phoneCallURL)
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
