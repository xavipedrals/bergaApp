//
//  EventDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class EventDetailViewController: MapViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var organizerImage: UIImageView!
    @IBOutlet weak var twitterBackground: CustomView!
    @IBOutlet weak var facebookBackground: CustomView!
    @IBOutlet weak var instagramBackground: CustomView!
    @IBOutlet weak var webBackground: CustomView!
    
    var event: CalendarEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        if let address = event?.address {
            addAddressPin(address.town)
        }
        
        dateLabel.text = Commons.getStringFromDate(date: event!.date, format: "dd MMMM YYYY")
    }
    
    func initVisuals() {
        set(title: event!.name.uppercased())
        set(type: event!.typeName)
    }
    
    func set(title: String) {
        titleLabel.attributedText = Commons.getAttributedCharSpacedText(title, charSpacing: 1.5)
    }
    
    func set(type: String) {
        typeLabel.attributedText = Commons.getAttributedCharSpacedText(type, charSpacing: 1.4)
    }
    
    func set(imgUrl: String?) {
        if let imgUrl = imgUrl {
            let url = URL(string: imgUrl)
            if let url = url {
                organizerImage.kf.setImage(with: url)
            }
        }
        else {
            //hide
        }
    }
    
    func set(description: String) {
        descriptionLabel.text = description
    }
    
    func set(price: String?) {
        if let price = price {
            priceLabel.text = price
        }
        else {
            priceLabel.text = "Esdeveniment gratuït"
        }
    }
    
    func set(organizer: EventOrganizer) {
        
    }
    
    func set(twitter: String?) {
        if let twitterUrl = twitter {
            twitterBackground.backgroundColor = Colors.dimGreen
        }
        else {
            twitterBackground.backgroundColor = UIColor.lightGray
        }
    }
    
    func set(facebook: String?) {
        
    }
    
    func set(instagram: String?) {
        
    }
    
    func set(web: String?) {
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
