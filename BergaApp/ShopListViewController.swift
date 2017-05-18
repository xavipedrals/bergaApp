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
        
    }


}
