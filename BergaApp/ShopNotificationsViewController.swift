//
//  ShopNotificationsViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShopNotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var shop: Shop?
    let shopNotificationsViewModel = ShopNotificationsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVisuals()
        
        shopNotificationsViewModel.notifications.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "shopNotificationCell", cellType: NotificationTableViewCell.self)) {
                _, notification, cell in
                cell.initCell(from: notification)
            }
            .addDisposableTo(disposeBag)
        
    }

    func initVisuals() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }

}
