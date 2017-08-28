//
//  MapSectionView.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 28/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable
class MapSectionView: CustomReusableView {
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityPostalCodeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    func set(address: Address) {
        mapView.delegate = self
        streetLabel.text = address.getTitle()
        cityPostalCodeLabel.text = address.getSubtitle()
        addAddressPin(address)
    }
    
    private func addAddressPin(_ address: Address) {
        let geocoder = CLGeocoder()
        
        let title = address.street ?? address.town
        let subtitle = title != address.town ? address.town : "Barcelona"
        
        geocoder.geocodeAddressString(address.getStringified(), completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let firstPlacemark = placemarks?.first {
                self.addPlacemarkToMap(placemark: firstPlacemark, title: title, subtitle: subtitle)
            }
        })
    }
    
    private func addPlacemarkToMap(placemark: CLPlacemark, title: String, subtitle: String) {
        let mkPlacemark = MKPlacemark(placemark: placemark)
        self.centerMapOnRegion(coordinates: mkPlacemark.coordinate)
        
        let customAnnotation = CustomAnnotation(title: title, subtitle: subtitle, coordinate: mkPlacemark.coordinate)
        self.mapView.addAnnotation(customAnnotation)
        self.mapView.selectAnnotation(customAnnotation, animated: true)
    }
    
    private func centerMapOnRegion(coordinates: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 2000
        let region = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)
        self.mapView.setRegion(region, animated: true)
    }
    
    override func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}

extension MapSectionView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            let view = getReusedAnnotation(annotation: annotation, identifier: identifier) ?? getNewAnnotation(annotation: annotation, identifier: identifier)
            return view
        }
        return nil
    }
    
    func getReusedAnnotation(annotation: MKAnnotation, identifier: String) -> MKPinAnnotationView? {
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            let view = dequeuedView
            view.canShowCallout = true
            return view
        }
        return nil
    }
    
    func getNewAnnotation(annotation: MKAnnotation, identifier: String) -> MKPinAnnotationView {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        return view
    }
}
