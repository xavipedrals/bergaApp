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
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var event: CalendarEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        initVisuals()
        
        if let address = event?.address {
            addAddressPin(address.town)
        }
        
        
    }
    
    func initVisuals() {
        set(date: event!.date)
        set(title: event!.name.uppercased())
        set(type: event!.typeName)
        set(imgUrl: event!.imgUrl)
        set(price: event!.price)
        set(organizer: event!.organizer)
        descriptionLabel.text = event!.description
    }
    
    func set(date: Date) {
        dateLabel.text = Commons.getStringFromDate(date: date, format: "dd MMMM YYYY")
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
                posterImageView.kf.setImage(with: url)
            }
        }
        else {
            imageSection.isHidden = true
        }
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
        organizerLabel.text = organizer.name
        set(twitter: organizer.twitterUrl)
        set(facebook: organizer.facebookUrl)
        set(instagram: organizer.instagramUrl)
        set(web: organizer.webUrl)
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
        if let twitterUrl = facebook {
            facebookBackground.backgroundColor = Colors.dimGreen
        }
        else {
            facebookBackground.backgroundColor = UIColor.lightGray
        }
    }
    
    func set(instagram: String?) {
        if let twitterUrl = instagram {
            instagramBackground.backgroundColor = Colors.dimGreen
        }
        else {
            instagramBackground.backgroundColor = UIColor.lightGray
        }
    }
    
    func set(web: String?) {
        if let twitterUrl = web {
            webBackground.backgroundColor = Colors.dimGreen
        }
        else {
            webBackground.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
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
