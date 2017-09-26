//
//  KeyboardViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 19/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UITextFieldDelegate {
    
    var isKeyboardShowing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isKeyboardShowing = false
        configureKeyboard()
    }
    
    func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name:NSNotification.Name.UIKeyboardDidHide, object: self.view.window)
        //CAN CAUSE PROBLEMS WHEN HAVING A DIALOG WITH AN EDITTEXT OVER A TABLEVIEW
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        isKeyboardShowing = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        isKeyboardShowing = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
