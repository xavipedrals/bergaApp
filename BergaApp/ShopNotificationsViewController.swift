//
//  ShopNotificationsViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 31/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShopNotificationsViewController: UIViewController {

    @IBOutlet weak var collectionView: CenteredCollectionView!
    
    let shopNotificationsViewModel = ShopNotificationsViewModel()
    var centeredScrollManager = CenteredScrollManager()
    let disposeBag = DisposeBag()
    
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationCollection()
    }
    
    func configureNotificationCollection() {
        setupCollectionLayout()
        
        shopNotificationsViewModel.notifications.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "notificationCell", cellType: NotificationCollectionViewCell.self)) {
                _, notification, cell in
                cell.initCell(notification: notification)
            }
            .addDisposableTo(disposeBag)
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func setupCollectionLayout() {
        setCellSize()
        collectionView.setup()
    }
}

extension ShopNotificationsViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCellSize()
    }
    
    func setCellSize () {
        cellWidth =  UIScreen.main.bounds.width - 40
        cellHeight = 160
        centeredScrollManager.set(pageWidth: cellWidth + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ShopNotificationsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = centeredScrollManager.getNextItemPoint(velocity: velocity, targetContentOffset: targetContentOffset, collectionContentSize: collectionView!.contentSize.width)
        targetContentOffset.pointee = point
    }
    
}
