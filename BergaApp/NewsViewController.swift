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
    @IBOutlet weak var weatherView: WeatherView!
    
    let newsViewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVisuals()
        let weather = Weather(celciusGrades: 24, type: .sunny)
        
        weatherView.set(weather: weather)
        
        newsViewModel.data.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsTableViewCell.self)){
                _, news, cell in
                cell.initCell(from: news)
                cell.shareButton.rx.tap
                    .subscribe(onNext: { _ in
                        self.share(news: news)
                    })
                    .addDisposableTo(self.disposeBag)
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(News.self)
            .subscribe(onNext: { news in
                UIApplication.shared.openURL(URL(string: news.url)!)
            })
            .addDisposableTo(disposeBag)
        
    }
    
    func initVisuals() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
}
