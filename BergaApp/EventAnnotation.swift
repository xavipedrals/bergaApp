//
//  EventAnnotation.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class EventAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(from placemark: MKPlacemark) {
        let titleArr = placemark.title?.components(separatedBy: ",")
        self.title = titleArr![0].replacingOccurrences(of: "Carrer", with: "C/")
        if let subtitle = titleArr?[1] {
            self.subtitle = subtitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        self.coordinate = placemark.coordinate
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
