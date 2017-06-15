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

    @IBOutlet weak var collectionView: UICollectionView!
    
    var shop: Shop?
    let shopNotificationsViewModel = ShopNotificationsViewModel()
    var cellWidth: Double?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopNotificationsViewModel.notifications.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "shopNotificationCell", cellType: NotificationCollectionViewCell.self)) {
                _, notification, cell in
                cell.initCell(from: notification)
            }
            .addDisposableTo(disposeBag)
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
    }
}


extension ShopNotificationsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: 200)
    }
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func setCellWidth () {
        let flow: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (collectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) * 2)
        cellWidth = Double(width)
    }
}
