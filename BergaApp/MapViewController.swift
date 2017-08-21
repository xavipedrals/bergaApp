//
//  MapViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 25/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    func addAddressPin(_ address: Address) {
        let geocoder = CLGeocoder()
        
        let title = address.street ?? address.town
        let subtitle = title != address.town ? address.town : "Barcelona"
        
        geocoder.geocodeAddressString(address.getStringified(), completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let firstPlacemark = placemarks?.first {
                
                let placemark = MKPlacemark(placemark: firstPlacemark)
                self.centerMapOnRegion(coordinates: placemark.coordinate)
                
//                let customAnnotation = CustomAnnotation(from: placemark)
                let customAnnotation = CustomAnnotation(title: title, subtitle: subtitle, coordinate: placemark.coordinate)
                
                self.mapView.addAnnotation(customAnnotation)
                self.mapView.selectAnnotation(customAnnotation, animated: true)
            }
        })
    }
    
    func centerMapOnRegion(coordinates: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 2000
        let region = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)
        self.mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.canShowCallout = true
            }
            else {
                view = getMKAnnotationView(annotation: annotation, identifier: identifier)
            }
            return view
        }
        return nil
    }
    
    func getMKAnnotationView(annotation: MKAnnotation, identifier: String) -> MKPinAnnotationView {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        return view
    }
}
