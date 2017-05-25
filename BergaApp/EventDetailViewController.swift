//
//  EventDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

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

extension EventDetailViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
                view = getMKAnnotationView(annotation: annotation, identifier: identifier)
            }
            return view
        }
        return nil
    }
    
    private func getMKAnnotationView(annotation: MKAnnotation, identifier: String) -> MKPinAnnotationView {
        var view: MKPinAnnotationView
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.rightCalloutAccessoryView = getDisclosureButton()
        view.leftCalloutAccessoryView = getLeftCalloutAccessoryView(height: view.frame.height)
        return view
    }
    
    private func getDisclosureButton() -> UIButton {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = Colors.red
        return button
    }
    
    private func getLeftCalloutAccessoryView(height: CGFloat) -> UIView {
        let leftView = getLeftCalloutView(height: height)
        let imageView = getIconImageView()
        
        let size = leftView.frame.size
        imageView.center = CGPoint(x: size.width/2, y: size.height/2)
        leftView.addSubview(imageView)
        
        return leftView
    }
    
    private func getLeftCalloutView(height: CGFloat) -> UIView {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: height + 12))
        leftView.backgroundColor = Colors.red
        return leftView
    }
    
    private func getIconImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: event!.type.rawValue))
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        return imageView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! EventAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
