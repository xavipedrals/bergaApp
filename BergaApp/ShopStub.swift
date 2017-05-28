//
//  ShopStub.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class ShopStub {
    
    func getStub() -> [Shop] {
        
        let shop1 = Shop(
            name: "Cal Alberich",
            description: "",
            isPromoted: true
        )
        shop1.description = "Cal Alberich és una botiga de Berga que fa pastissos i altres coses de 1981. Som els més bla bla bla de els més bla bla bla, us estimem molt a tots, sigueu benvinguts a casa nostra."
        shop1.phone = 934567889
        shop1.schedule = "Obert tots els dies entre setmana de 8am a 20pm. Els dissabtes obrim de 9am a 15pm"
        shop1.url = "https://www.google.es"
        shop1.photosUrls = ["https://s-media-cache-ak0.pinimg.com/originals/cb/32/66/cb32666ae5aa7d180083b2fc1f76be1d.jpg",
                                 "http://lh3.googleusercontent.com/-ldH4dMCpO48/ViE15jwk9HI/AAAAAAABF4U/ECNYUJ29y3o/s640/blogger-image-881916915.jpg",
                                 "https://media-cdn.tripadvisor.com/media/photo-s/03/57/95/2e/boulangerie-patisserie.jpg"]
        shop1.address = "Carrer de la Mare de Déu dels Àngels, 15, 08600 Berga, Barcelona"
        
        let shop2 = Shop(
            name: "Super2",
            description: "Quiosc i botiga de joguines."
        )
        
        let shop3 = Shop(
            name: "Cal Negre",
            description: "Bar restaurant."
        )
        
        let shop4 = Shop(
            name: "Bar Ski",
            description: "",
            isPromoted: true
        )
        shop4.description = "El bar Ski és un bar de tota la vida de Berga, el porta el senyor Trans un tiu molt trempat."
        shop4.phone = 934567889
        shop4.schedule = "Obert tots els dies entre setmana de 8am a 23pm. Els dissabtes obrim de 9am a 1am."
//        shop4.url = "https://www.google.es"
        shop4.photosUrls = ["https://media-cdn.tripadvisor.com/media/photo-s/05/fb/ea/3c/bar-ski.jpg",
                            "http://www.stayinbath.org/wp-content/uploads/2015/11/apres_ski_bar.jpg"]
        shop4.address = "Passeig de la Pau, 5, 08600 Berga, Barcelona"
        
        let shop5 = Shop(
            name: "Domti",
            description: "Tot a cent."
        )
        
        let shop6 = Shop(
            name: "La Tosca",
            description: "Bar restaurant."
        )
        
        let shop7 = Shop(
            name: "Xauxa",
            description: "",
            isPromoted: true
        )
        shop7.description = "Cal Alberich és una botiga de Berga que fa pastissos i altres coses de 1981. Som els més bla bla bla de els més bla bla bla, us estimem molt a tots, sigueu benvinguts a casa nostra."
        shop7.phone = 934567889
        shop7.schedule = "Obert tots els dies entre setmana de 8am a 20pm. Els dissabtes obrim de 9am a 15pm"
        shop7.url = "https://www.google.es"
        shop7.photosUrls = ["https://s-media-cache-ak0.pinimg.com/originals/cb/32/66/cb32666ae5aa7d180083b2fc1f76be1d.jpg",
                            "http://lh3.googleusercontent.com/-ldH4dMCpO48/ViE15jwk9HI/AAAAAAABF4U/ECNYUJ29y3o/s640/blogger-image-881916915.jpg",
                            "https://media-cdn.tripadvisor.com/media/photo-s/03/57/95/2e/boulangerie-patisserie.jpg"]
        shop7.address = "Carrer de la Mare de Déu dels Àngels, 15, 08600 Berga, Barcelona"
        
        let shop8 = Shop(
            name: "Lladó llums",
            description: "Botiga de llums."
        )
        
        let shop9 = Shop(
            name: "Cal Fígols",
            description: "Botiga de roba."
        )
        
        let shop10 = Shop(
            name: "Cal Blasi",
            description: "Bar restaurant."
        )
        
        let shop11 = Shop(
            name: "Xarcuteria Portell",
            description: "Carnisseria."
        )
        
        let shop12 = Shop(
            name: "Forn Lluís Millet",
            description: "Forn."
        )
        
        return [shop1, shop2, shop3, shop4, shop5, shop6, shop7, shop8, shop9, shop10, shop11, shop12]
        
    }
    
        
}
