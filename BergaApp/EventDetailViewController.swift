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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var event: CalendarEvent?
    var eventAnnotation: EventAnnotation?
    var initialLocation: CLLocation?
    let regionRadius: CLLocationDistance = 750
    let defaultInitialLocation = CLLocation(latitude: 42.1012595, longitude: 1.8439221) //Berga
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = event?.name
        iconImageView.image = UIImage(named: event!.type.rawValue)
        iconImageView.iconTint = UIColor.gray
        
        mapView.delegate = self
        
        if let coordinates = event?.localization {
            eventAnnotation = EventAnnotation(from: event!)
            mapView.addAnnotation(eventAnnotation!)
            mapView.selectAnnotation(eventAnnotation!, animated: false)
            
            initialLocation = CLLocation(latitude: coordinates.lat, longitude: coordinates.long)
            centerMapOnLocation(location: initialLocation!)
        }
        else {
            centerMapOnLocation(location: defaultInitialLocation)
        }
        
        
        
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension EventDetailViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                let imageView = UIImageView(image: UIImage(named: "majorFest"))
//                imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
//                imageView.tintColor = UIColor.white
//                imageView.backgroundColor = Colors.red
                
                let auxView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
                auxView.backgroundColor = Colors.red
                let imageView = UIImageView(image: UIImage(named: "majorFest"))
                auxView.addSubview(imageView)
                
                view.leftCalloutAccessoryView = auxView
            }
            return view
        }
        return nil
    }
    
    func  mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! EventAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
