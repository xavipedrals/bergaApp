//
//  ShopDetailStub.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 23/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class ShopDetailStub {
    
    static func getStub(shop: Shop) -> ShopDetail {
        let shopDetail = ShopDetail(from: shop)
        shopDetail.description = "Cal Alberich és una botiga de Berga que fa pastissos i altres coses de 1981. Som els més bla bla bla de els més bla bla bla, us estimem molt a tots, sigueu benvinguts a casa nostra."
        shopDetail.phone = 934567889
        shopDetail.schedule = "Obert tots els dies entre setmana de 8am a 20pm. Els dissabtes obrim de 9am a 15pm"
        shopDetail.url = "https://www.google.es"
        shopDetail.photosUrls = ["https://s-media-cache-ak0.pinimg.com/originals/cb/32/66/cb32666ae5aa7d180083b2fc1f76be1d.jpg",
                                 "http://lh3.googleusercontent.com/-ldH4dMCpO48/ViE15jwk9HI/AAAAAAABF4U/ECNYUJ29y3o/s640/blogger-image-881916915.jpg",
                                 "https://media-cdn.tripadvisor.com/media/photo-s/03/57/95/2e/boulangerie-patisserie.jpg"]
        return shopDetail
    }
}
