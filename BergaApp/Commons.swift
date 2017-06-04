//
//  Commons.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class Commons {
    
    static func getStringFromDate(date: Date, format: String) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        let dateStr = dateFormat.string(from: date)
        return dateStr
    }
    
    static func getDateFromString(date: String, format: String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let someDateTime = formatter.date(from: date)
        return someDateTime
    }
    
    static func getAttributedLineSpaceText(_ text: String, lineSpacing: Double) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        return attrString
    }
    
    static func getAttributedCharSpacedText(_ text: String, charSpacing: Double) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(charSpacing), range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
}

extension Date {
    func startOfMonth() -> Date {
        let comp: DateComponents = Calendar.current.dateComponents([.day], from: self)
        var comps2 = DateComponents()
        comps2.day = -(comp.day! - 1)
        let startOfMonth = Calendar.current.date(byAdding: comps2, to: self)!
        return startOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func nextMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    func previousMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
    }
}

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: Double) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a))
    }
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension String {
    var length: Int {
        return self.characters.count
    }
}
