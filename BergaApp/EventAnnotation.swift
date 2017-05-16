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
//    var subtitle: String?
    var locationName: String
    var discipline: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(from event: CalendarEvent) {
        self.title = event.name
        self.locationName = "Berga, el millor poble de tots els pobles que es fan i es desfan"
        self.discipline = "sida"
        self.coordinate = CLLocationCoordinate2D(latitude: event.localization!.lat, longitude: event.localization!.long)
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
