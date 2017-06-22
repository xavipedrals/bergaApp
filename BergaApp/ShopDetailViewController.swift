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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var subMenuContainer: UIView!
    
    var shop: Shop?
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = shop?.name
        configSubmenu()
    }
    
    func configSubmenu() {
        if !shop!.isPromoted {
            subMenuContainer.isHidden = true
        }
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
    
    @IBAction func informationPressed(_ sender: Any) {
        notificationsContainerView.isHidden = true
        infoContainerView.isHidden = false
        infoLabel.textColor = Colors.dimGreen
        notificationsLabel.textColor = Colors.lightGray
    }

    @IBAction func notificationsPressed(_ sender: Any) {
        notificationsContainerView.isHidden = false
        infoContainerView.isHidden = true
        infoLabel.textColor = Colors.lightGray
        notificationsLabel.textColor = Colors.dimGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
