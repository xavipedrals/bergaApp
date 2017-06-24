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
    let disposeBag = DisposeBag()
    
    init() {
        getNews()
    }
    
    func getNews() {
//        data.value = NewsStub().getStub()
        
        RxAlamofire.requestJSON(.get, "http://www.mocky.io/v2/594c00501100001f01a3cfba")
//            .debug()
            .subscribe(onNext: { response, data in
                response.statusCode == 200
                    ? self.fetchNews(data: data)
                    : print("News status code is \(response.statusCode)")
            },
            onError: { error in
                print(error)
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchNews(data: Any) {
        let json = JSON(data)
        let news = json["news"].arrayValue
        self.data.value = ArrayParser<News>.parseJSONToArray(news)
    }
    
}
