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
    
    func addAddressPin(_ address: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let firstPlacemark = placemarks?.first {
                
                let placemark = MKPlacemark(placemark: firstPlacemark)
                self.centerMapOnRegion(coordinates: placemark.coordinate)
                
                let customAnnotation = CustomAnnotation(from: placemark)
                
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
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.canShowCallout = true
                view.rightCalloutAccessoryView = getDisclosureButton()
            }
            else {
                view = getMKAnnotationView(annotation: annotation, identifier: identifier)
            }
            return view
        }
        return nil
    }
    
    func getMKAnnotationView(annotation: MKAnnotation, identifier: String, imgName: String) -> MKPinAnnotationView {
        let view = getMKAnnotationView(annotation: annotation, identifier: identifier)
        view.leftCalloutAccessoryView = getLeftCalloutAccessoryView(height: view.frame.height, imgName: imgName)
        return view
    }
    
    func getMKAnnotationView(annotation: MKAnnotation, identifier: String) -> MKPinAnnotationView {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
//        view.rightCalloutAccessoryView = getDisclosureButton()
        return view
    }
    
    func getDisclosureButton() -> UIButton {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = Colors.red
        return button
    }
    
    private func getLeftCalloutAccessoryView(height: CGFloat, imgName: String) -> UIView {
        let leftView = getLeftCalloutView(height: height)
        let imageView = getIconImageView(imgName: imgName)
        
        let size = leftView.frame.size
        imageView.center = CGPoint(x: size.width/2, y: size.height/2)
        leftView.addSubview(imageView)
        
        return leftView
    }
    
    private func getLeftCalloutView(height: CGFloat) -> UIView {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: height + 12))
        leftView.backgroundColor = Colors.dimGreen
        return leftView
    }
    
    private func getIconImageView(imgName: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imgName))
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        return imageView
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! CustomAnnotation
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
//    }
}
