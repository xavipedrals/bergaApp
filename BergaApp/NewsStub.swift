//
//  NewsStub.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 13/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation

class NewsStub {
    
    func getStub() -> [News] {
        
        let new1 = News(title: "Clam multitudinari a favor de la mineria a la Catalunya Central",
                        subtitle: "Sectors socials, econòmics i polítics del territori reclamen una moratòria perquè Iberpotash pugui seguir abocant al Cogulló",
                        url: "http://www.naciodigital.cat/bergueda/noticia/9734/clam/multitudinari/favor/mineria/catalunya/central",
                        provider: NewsProvider(.nacioDigital),
                        imageUrl: "https://dades.naciodigital.cat/redaccio/arxius/imatges/201705/576_1494706347foto_3210528.jpg",
                        timestamp: Date()) //yyyy-MM-ddThh:mmZ
        
        let new2 = News(title: "La colla dels plens de la Patum manté viu el conflicte dels expulsats",
                        subtitle: "Es resisteix a acatar la readmissió acordada pel patronat i considera suspeses les decisions de la reunió",
                        url: "http://www.regio7.cat/bergueda/2017/05/13/plens-no-acaten-acords-del/414412.html",
                        provider: NewsProvider(.regio7),
                        imageUrl: "http://fotos01.regio7.cat/2017/05/13/328x206/els-plens.jpg",
                        timestamp: Date())
        
        let new3 = News(title: "Puig-reig, castell de Guillem de Berguedà i comanda templera",
                        subtitle: "El castell de Puig-reig, Guillem de Berguedà i els templers protagonitzen l’últim llibre de l’historiador Eudald Serra, ‘Puig-reig, castell de Guillem de Berguedà i comanda templera’, fruit de l’anàlisi de tota la documentació trobada relacionada amb la fortificació, des dels seus inicis fins a l’actualitat.",
                        url: "http://panxing.net/bergueda/cultura/puig-reig-castell-de-guillem-de-bergueda-i-comanda-templera-d-eudald-serra",
                        provider: NewsProvider(.panxing),
                        imageUrl: "http://panxing.net/media/k2/items/cache/23a32c98b4d9a50146f7103dfb75ce48_L.jpg",
                        timestamp: Date())
        
        let new4 = News(title: "El Festival de la Baells es vol consolidar com un motor d’activitat al pantà en temporada d’estiu",
                        subtitle: "L’edició d’aquest any espera milers de visitants i aposta amb fermesa per la pesca i per noves activitats esportives repartides entre maig i setembre",
                        url: "http://www.aquibergueda.cat/2017/05/12/170097/",
                        provider: NewsProvider(.aquiBergueda),
                        imageUrl: "",
                        timestamp: Date())
        
        let new5 = News(title: "Ciberatac global contra empreses i organismes públics de diversos països",
                        subtitle: "Un atac informàtic massiu ha infectat desenes de milers d'ordinadors d'organismes públics, governs i grans empreses de fins a 74 països, segons ha piulat el director de l'equip de recerca global i anàlisi de la multinacional russa de la ciberseguretat Kaspersky, Costin Raiu. La xifra és aproximada i creix a tota velocitat: l'empresa d'antivirus Avast parla de com a mínim 57.",
                        url: "http://www.ara.cat/economia/Telefonica-pateix-informatic-xarxa-interna_0_1794420671.html",
                        provider: NewsProvider(.ara),
                        imageUrl: "http://www.ara.cat/2017/05/12/imatges/Mapa-afectacions-del-ciberatac_1794430846_40789262_150x110.jpg",
                        timestamp: Date())
        
        let new6 = News(title: "I tot per no haver actualitzat Windows",
                        subtitle: "Mentre Nikolaos Tsouroulas explicava ahir sobre l’escenari del Connected Hub, a l’Automobile Barcelona, els múltiples riscos que amenacen la seguretat dels cotxes connectats, el telèfon que portava a la butxaca treia fum amb missatges de WhatsApp. Tsouroulas és el director global de productes de ciberseguretat d’Eleven Paths, l’empresa que Telefónica va crear el 2013 per oferir serveis de seguretat digital a les empreses, i els seus companys a Madrid l’anaven informant dels seus esforços per contenir el ciberatac que en aquell moment patien els ordinadors de la xarxa interna de l’operadora.",
                        url: "http://www.ara.cat/tema_del_dia/importancia-dactualitzar-sistema-operatiu_0_1795020650.html",
                        provider: NewsProvider(.ara),
                        imageUrl: "http://www.ara.cat/2017/05/13/tema_del_dia/Nikolaos-Tsouroulas-dirigeix-seguretat-Telefonica_1795030673_40805182_300x169.jpg",
                        timestamp: Date())
        
        let newsArray = [News]([new1, new2, new3, new4, new5, new6])
        
        return newsArray
    }
}
