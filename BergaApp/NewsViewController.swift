//
//  NewsViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let newsViewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVisuals()
        
        newsViewModel.data.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsTableViewCell.self)){
                _, news, cell in
                cell.initCell(from: news)
            }
            .addDisposableTo(disposeBag)
        
    }
    
    func initVisuals() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }

    
}
