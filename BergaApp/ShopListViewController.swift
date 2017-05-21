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

    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    
    let shopListViewModel = ShopListViewModel()
    let dataSource = RxTableViewSectionedReloadDataSource<ShopSection>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        shopListViewModel.shops.asObservable()
//            .bind(to: tableView.rx.items(cellIdentifier: "shopCell", cellType: ShopTableViewCell.self)) {
//                _, shop, cell in
//                cell.initCell(from: shop)
//            }
//            .addDisposableTo(disposeBag)
        
        shopListViewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = { ds, tv, indexPath, item in
            if item.isPromoted {
                let cell = tv.dequeueReusableCell(withIdentifier: "promotedShopCell", for: indexPath) as! PromotedShopTableViewCell
                cell.initCell(from: item)
                return cell
            }
            else {
                let cell = tv.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTableViewCell
                cell.initCell(from: item)
                return cell
            }
            
        }
        
        tableView.rx.modelSelected(Shop.self)
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
        
    }

    func createSearchBar() {
//        searchBar.showsCancelButton = true
        searchBar.placeholder = "Buscar"
        self.navigationItem.titleView = searchBar
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }

}
