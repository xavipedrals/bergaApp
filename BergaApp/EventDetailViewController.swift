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
    @IBOutlet weak var twitterBackground: SocialButtonBackground!
    @IBOutlet weak var facebookBackground: SocialButtonBackground!
    @IBOutlet weak var instagramBackground: SocialButtonBackground!
    @IBOutlet weak var webBackground: SocialButtonBackground!
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterContainer: UIView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityPostalCodeLabel: UILabel!
    
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
        set(title: event!.name)
        set(imgUrl: event!.imgUrl)
        set(price: event!.price)
        set(organizer: event!.organizer)
        set(address: event!.address)
        descriptionLabel.text = event!.description
    }
    
    func set(date: Date) {
        typeLabel.text = Commons.getStringFromDate(date: date, format: "dd MMMM YYYY").uppercased()
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(imgUrl: String?) {
        if let imgUrl = imgUrl {
            posterContainer.dropShadow()
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
        set(organizerImgUrl: organizer.imgUrl)
    }
    
    func set(twitter: String?) {
        twitterBackground.configure(url: twitter)
    }
    
    func set(facebook: String?) {
        facebookBackground.configure(url: facebook)
    }
    
    func set(instagram: String?) {
        instagramBackground.configure(url: instagram)
    }
    
    func set(web: String?) {
        webBackground.configure(url: web)
    }
    
    func set(organizerImgUrl: String?) {
        if let organizerImgUrl = organizerImgUrl {
            if let url = URL(string: organizerImgUrl) {
                organizerImage.kf.setImage(with: url)
            }
        }
    }
    
    func set(address: Address?) {
        if let address = address {
            if let street = address.street {
                streetLabel.text = street
            }
            if let postalCode = address.postalCode {
                cityPostalCodeLabel.text = address.town + ", " + postalCode
            }
        }
    }

    @IBAction func socialPressed(_ sender: UIButton) {
        var url: String?
        switch sender.tag {
        case 0:
            url = event?.organizer.twitterUrl
        case 1:
            url = event?.organizer.facebookUrl
        case 2:
            url = event?.organizer.instagramUrl
        case 3:
            url = event?.organizer.webUrl
        default:
            break
        }
        if let url = url {
            UIApplication.shared.openURL(URL(string: url)!)
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
