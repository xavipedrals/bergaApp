//
//  ShopsViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 17/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShopsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedShop: Shop?
    let shopListViewModel = ShopListViewModel()
    let disposeBag = DisposeBag()
    
    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(10)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    var currentItem = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionLayout()
        setupCollectionCells()
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func setupCollectionLayout() {
        setCollectionItemSize()
        let layout = getCollectionLayout()
        collectionView!.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func setCollectionItemSize() {
        cellWidth =  UIScreen.main.bounds.width - 40
        cellHeight = UIScreen.main.bounds.width * 0.8
    }
    
    func getCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: 20, height: 0)
        layout.footerReferenceSize = CGSize(width: 20, height: 0)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func setupCollectionCells() {
        shopListViewModel.topShops.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "topShopCell", cellType: TopShopCollectionViewCell.self)) {
                _, shop, cell in
                cell.initCell(from: shop)
            }
            .addDisposableTo(disposeBag)
    }
    
}

extension ShopsViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCollectionItemSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ShopsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(cellWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width)
        
        var newPage = Float(currentItem)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        }
        else {
            newPage = Float(velocity.x > 0 ? currentItem + 1 : currentItem - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        currentItem = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }

}
