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
    let shopListViewModel = ShopListViewModel()
    let dataSource = RxCollectionViewSectionedReloadDataSource<ShopSection>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
            let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shopHeader", for: indexPath) as! SectionHeaderCollectionReusableView
            
            header.initHeader(title: ds[indexPath.section].header)
            return header
        }
        
        collectionView.rx.modelSelected(Shop.self)
            .subscribe(onNext: { shop in
                self.performSegue(withIdentifier: "goToShopDetail", sender: nil)
            })
            .addDisposableTo(disposeBag)
        
        createSearchBar()
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { _ in
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        
        collectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
    }

    func createSearchBar() {
//        searchBar.showsCancelButton = true
        searchBar.placeholder = "Buscar"
        self.navigationItem.titleView = searchBar
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
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
