//
//  NewsViewModel.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 12/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON

class NewsViewModel {
    
    let data = Variable<[News]>([])
    var news = Variable<[NewsSection]>([
        NewsSection(name: "Top news", items: []),
        NewsSection(name: "Other news", items: [])
    ])
    var headerSection: NewsSection {
        get {
            return news.value[0]
        }
    }
    var allNewsSection: NewsSection {
        get {
            return news.value[1]
        }
    }
    let disposeBag = DisposeBag()
    
    init() {
        getNews()
    }
    
    func getNews() {
        RxAlamofire.requestJSON(.get, "http://www.mocky.io/v2/594c00501100001f01a3cfba")
//            .debug()
            .subscribe(onNext: { response, data in
                response.statusCode == 200
                    ? self.fetchNews(data: data)
                    : self.getStubNews()
//                    : print("News status code is \(response.statusCode)")
            },
            onError: { error in
                print(error)
                self.getStubNews()
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchNews(data: Any) {
        let json = JSON(data)
        let newsJson = json["news"].arrayValue
        let newsArray = ArrayParser<News>.parseJSONToArray(newsJson)
        news.value[0] = NewsSection(original: headerSection, items: [newsArray[0]])
        let allNews = [News](newsArray[1..<newsArray.count])
        news.value[1] = NewsSection(original: allNewsSection, items: allNews)
    }
    
    private func getStubNews() {
        let newsArray = NewsStub().getStub()
        news.value[0] = NewsSection(original: headerSection, items: [newsArray[0]])
        let allNews = [News](newsArray[1..<newsArray.count])
        news.value[1] = NewsSection(original: allNewsSection, items: allNews)
    }
    
}
