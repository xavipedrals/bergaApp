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
import RxDataSources

class ShopNotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var shop: Shop?
    let shopNotificationsViewModel = ShopNotificationsViewModel()
    let dataSource = RxTableViewSectionedReloadDataSource<NotificationSection>()
    var cellWidth: Double?
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
        
        configureCollectionView()
        
    }
    
    func initVisuals() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
    }
    
    func configureCollectionView() {
        bindDataSource()
        configureCells()
    }
    
    func bindDataSource() {
        shopNotificationsViewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func configureCells() {
        dataSource.configureCell = { (ds, tv, indexPath, item) in
            switch item {
            case .header(let newest):
                let cell = tv.dequeueReusableCell(withIdentifier: "notificationHeaderCell", for: indexPath) as! NotificationHeaderTableViewCell
                cell.initCell(isNewest: newest, count: self.shopNotificationsViewModel.newNotificationsCount)
                return cell
                
            case .shopNotification(let notification):
                let cell = tv.dequeueReusableCell(withIdentifier: "shopNotificationCell", for: indexPath) as! NotificationTableViewCell
                cell.initCell(from: notification)
                return cell
            }
        }
    }
    
    
}



