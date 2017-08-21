//
//  ImageDisplayViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 17/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher

class ImageDisplayViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var imgUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
    }
    
    func setImage() {
        if let imgUrl = self.imgUrl {
            if let url = URL(string: imgUrl) {
                imageView.kf.setImage(with: url)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
