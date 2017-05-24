//
//  ShopListViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ShopListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchBar = UISearchBar()
    var cellWidth: Double?
    var selectedShop: Shop?
    let shopListViewModel = ShopListViewModel()
    let dataSource = RxCollectionViewSectionedReloadDataSource<ShopSection>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionCells()
        createCollectionHeaders()
        createSearchBar()
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
    }
    
    func createCollectionCells() {
        shopListViewModel.sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = { ds, cv, indexPath, item in
            if item.isPromoted {
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "promotedShopCell", for: indexPath) as! PromotedShopCollectionViewCell
                cell.initCell(from: item)
                return cell
            }
            else {
                let cell = cv.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! ShopCollectionViewCell
                cell.initCell(from: item)
                return cell
            }
        }
        
        collectionView.rx.modelSelected(Shop.self)
            .subscribe(onNext: { shop in
                if shop.isPromoted {
                    self.selectedShop = shop
                    self.performSegue(withIdentifier: "goToShopDetail", sender: nil)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func createCollectionHeaders() {
        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shopHeader", for: indexPath) as! SectionHeaderCollectionReusableView
            
            header.initHeader(title: ds[indexPath.section].header)
            return header
        }
    }

    func createSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Buscar"
        self.navigationItem.titleView = searchBar
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { _ in
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: self.shopListViewModel.searchString)
            .addDisposableTo(disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { _ in
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: {
                self.searchBar.setShowsCancelButton(true, animated: true)
            })
            .addDisposableTo(disposeBag)
        
        searchBar.rx.textDidEndEditing
            .subscribe(onNext: {
                self.searchBar.setShowsCancelButton(false, animated: true)
            })
            .addDisposableTo(disposeBag)

    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToShopDetail" {
            let vc = segue.destination as! ShopDetailViewController
            vc.shop = selectedShop
        }
    }

}

extension ShopListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: 42)
    }
    
    func setCellWidth () {
        let flow: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (collectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) * 2)
        cellWidth = Double(width)
    }
}
