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
    var eventAnnotation: EventAnnotation?
    var initialLocation: CLLocation?
    let regionRadius: CLLocationDistance = 750
    let defaultInitialLocation = CLLocation(latitude: 42.1012595, longitude: 1.8439221) //Berga
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = event?.name
        self.navigationItem.backBarButtonItem?.title = ""
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
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

                let auxView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: view.frame.height + 12))

                auxView.backgroundColor = Colors.red
                let imageView = UIImageView(image: UIImage(named: event!.type.rawValue))
                imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = UIColor.white
                
                let size: CGSize = auxView.frame.size
                imageView.center = CGPoint(x: size.width/2, y: size.height/2)

                
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
