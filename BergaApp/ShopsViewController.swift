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

    @IBOutlet weak var collectionView: CenteredCollectionView!
    
    var selectedShop: Shop?
    let shopListViewModel = ShopListViewModel()
    var centeredScrollManager = CenteredScrollManager()
    let disposeBag = DisposeBag()
    
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionLayout()
        setupCollectionCells()
        observeCellClicks()
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func setupCollectionLayout() {
        setCollectionItemSize()
        collectionView.setup(cellWidth: cellWidth, cellHeight: cellHeight)
    }
    
    func setupCollectionCells() {
        shopListViewModel.topShops.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "topShopCell", cellType: TopShopCollectionViewCell.self)) {
                _, shop, cell in
                cell.initCell(from: shop)
            }
            .addDisposableTo(disposeBag)
    }
    
    func observeCellClicks() {
        collectionView.rx.modelSelected(Shop.self)
            .subscribe(onNext: { shop in
                self.selectedShop = shop
                self.performSegue(withIdentifier: "goToShopDetail", sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToShopDetail" {
            let vc = segue.destination as! ShopInfoViewController
            vc.shop = selectedShop
        }
    }
}

extension ShopsViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCollectionItemSize()
    }
    
    func setCollectionItemSize() {
        cellWidth =  UIScreen.main.bounds.width - 40
        cellHeight = UIScreen.main.bounds.width * 0.8
        centeredScrollManager.set(pageWidth: cellWidth + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ShopsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = centeredScrollManager.getNextItemPoint(velocity: velocity, targetContentOffset: targetContentOffset, collectionContentSize: collectionView!.contentSize.width)
        targetContentOffset.pointee = point
    }
}
