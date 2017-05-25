//
//  EventDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: MapViewController {

    @IBOutlet weak var iconImageView: IconImage!
    @IBOutlet weak var mapView: MKMapView!
    
    var event: CalendarEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = event?.name
        self.navigationItem.backBarButtonItem?.title = ""
        mapView.delegate = self
        
        if let address = event?.address {
            addAddressPin(address)
        }
        
    }
    
    func addAddressPin(_ address: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let firstPlacemark = placemarks?.first {
                
                let placemark = MKPlacemark(placemark: firstPlacemark)
                self.centerMapOnRegion(coordinates: placemark.coordinate)
                
                let eventAnnotation = EventAnnotation(from: placemark)
                
                self.mapView.addAnnotation(eventAnnotation)
                self.mapView.selectAnnotation(eventAnnotation, animated: true)
            }
        })
    }
    
    func centerMapOnRegion(coordinates: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 2000
        let region = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)
        self.mapView.setRegion(region, animated: true)
    }

}


extension EventDetailViewController {
    
    override func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.canShowCallout = true
                view.rightCalloutAccessoryView = getDisclosureButton()
            }
            else {
                view = getMKAnnotationView(annotation: annotation, identifier: identifier, imgName: event!.type.rawValue)
            }
            return view
        }
        return nil
    }
    
}
