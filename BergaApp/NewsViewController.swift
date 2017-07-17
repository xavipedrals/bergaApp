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
import RxDataSources

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<NewsSection>()
    let newsViewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    let headerNewsCellIdentifier = "newsHeaderCell"
    let newsCellIdentifier = "newsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVisuals()
        configureTableView()
    }
    
    func initVisuals() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    func configureTableView() {
        configureNews()
        configureShareNews()
    }
    
    func configureNews() {
        newsViewModel.news.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = { (ds: TableViewSectionedDataSource<NewsSection>, tv: UITableView, index: IndexPath, item: NewsSection.Item) -> UITableViewCell in
            if index.section == 0 {
                return self.getHeaderCell(index: index, news: item)
            }
            else {
                return self.getNewsCell(index: index, news: item)
            }
        }
    }
    
    func getHeaderCell(index: IndexPath, news: News) -> NewsTitleTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerNewsCellIdentifier, for: index) as! NewsTitleTableViewCell
        cell.initCell(from: news)
        cell.shareButton.rx.tap
            .subscribe(onNext: { _ in
                self.share(news: news)
            })
            .addDisposableTo(self.disposeBag)
        return cell
    }
    
    func getNewsCell(index: IndexPath, news: News) -> NewsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIdentifier, for: index) as! NewsTableViewCell
        cell.initCell(from: news)
        cell.shareButton.rx.tap
            .subscribe(onNext: { _ in
                self.share(news: news)
            })
            .addDisposableTo(self.disposeBag)
        return cell
    }
    
    func configureShareNews() {
        tableView.rx.modelSelected(News.self)
            .subscribe(onNext: { news in
                UIApplication.shared.openURL(URL(string: news.url)!)
            })
            .addDisposableTo(disposeBag)
    }
    
    func share(news: News) {
        let message = "Mira quina notícia he trobat a BergaApp: "
        if let link = NSURL(string: news.url){
            
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .openInIBooks, .print, .saveToCameraRoll, UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"), UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")]
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}
