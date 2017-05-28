//
//  ShopDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 20/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var notificationsContainerView: UIView!
    @IBOutlet weak var segmentWrapper: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    var shop: Shop?
    let notificationsActivated = Variable<Bool>(false)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = shop?.name
        self.navigationItem.backBarButtonItem?.title = ""
        if !shop!.isPromoted {
            self.navigationItem.rightBarButtonItem = nil
            segmentWrapper.removeFromSuperview()
            self.view.needsUpdateConstraints()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
//        self.segmentWrapper. = !shop!.isPromoted
//        segmentControl.isEnabled = shop!.isPromoted
        
        notificationsActivated.asObservable()
            .map({
                $0 ? "notifications" : "notification_none"
            })
            .subscribe(onNext: { imgName in
                self.navigationItem.rightBarButtonItem?.image = UIImage(named: imgName)
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        changeSegment()
    }
    
    func changeSegment() {
        notificationsContainerView.isHidden = !notificationsContainerView.isHidden
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopInfoSegue" {
            let shopInfoVC = segue.destination as! ShopInfoViewController
            shopInfoVC.shop = self.shop
        }
        else if segue.identifier == "shopNotificationsSegue" {
            let shopNotificationsVC = segue.destination as! ShopNotificationsViewController
            shopNotificationsVC.shop = self.shop
        }
    }
    
    @IBAction func notificationsPressed(_ sender: Any) {
        notificationsActivated.value = !notificationsActivated.value
    }

}
