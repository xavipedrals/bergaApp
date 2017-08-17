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
    
    var cellWidth: Double?
    var selectedShop: Shop?
    let shopListViewModel = ShopListViewModel()
    let disposeBag = DisposeBag()
    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(10)
    var itemHeight = CGFloat(0)
    var itemWidth = CGFloat(0)
    var currentItem = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        
//        itemWidth =  UIScreen.main.bounds.width - 40
//        itemHeight = UIScreen.main.bounds.width * 0.8
//        
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        layout.headerReferenceSize = CGSize(width: 20, height: 0)
//        layout.footerReferenceSize = CGSize(width: 20, height: 0)
//        layout.minimumLineSpacing = 10
//        layout.scrollDirection = .horizontal
//        
//        collectionView!.collectionViewLayout = layout
//        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        
        
        
        shopListViewModel.topShops.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "topShopCell", cellType: TopShopCollectionViewCell.self)) {
                _, shop, cell in
                cell.initCell(from: shop)
            }
            .addDisposableTo(disposeBag)
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    
}

extension ShopsViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = Double(UIScreen.main.bounds.width)
        return CGSize(width: cellWidth!, height: screenWidth * 0.8)
    }
    
    func setCellWidth () {
        let flow: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (collectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) - 40)
        cellWidth = Double(width)
    }
}

extension ShopsViewController: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        
//        let pageWidth = Float(itemWidth + itemSpacing)
//        let targetXContentOffset = Float(targetContentOffset.pointee.x)
//        let contentWidth = Float(collectionView!.contentSize.width  )
//        
////        var newPage = Float(self.pageControl.currentPage)
//        
//        if velocity.x == 0 {
//            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
//        } else {
//            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
//            if newPage < 0 {
//                newPage = 0
//            }
//            if (newPage > contentWidth / pageWidth) {
//                newPage = ceil(contentWidth / pageWidth) - 1.0
//            }
//        }
////        self.pageControl.currentPage = Int(newPage)
//        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
//        targetContentOffset.pointee = point
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            var currentCellOffset = self.collectionView.contentOffset
            currentCellOffset.x += self.collectionView.frame.width / 2
            if let indexPath = self.collectionView.indexPathForItem(at: currentCellOffset) {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }

}
