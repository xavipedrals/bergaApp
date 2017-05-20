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

class ShopListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    
    let shopListViewModel = ShopListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopListViewModel.shops.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "shopCell", cellType: ShopTableViewCell.self)) {
                _, shop, cell in
                cell.initCell(from: shop)
            }
            .addDisposableTo(disposeBag)
        
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
