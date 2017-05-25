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

}


extension EventDetailViewController {
    
    override func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
                view = getMKAnnotationView(annotation: annotation, identifier: identifier, imgName: event!.type.rawValue)
            }
            return view
        }
        return nil
    }
    
}
