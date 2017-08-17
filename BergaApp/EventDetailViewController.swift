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
import RxSwift
import RxCocoa

class EventDetailViewController: MapViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var organizerImage: UIImageView!
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterContainer: UIView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityPostalCodeLabel: UILabel!
    @IBOutlet weak var titleSection: TitleSectionView!
    @IBOutlet weak var descriptionSection: TextSectionView!
    @IBOutlet weak var socialBar: SocialBarView!
    
    var event: CalendarEvent?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        initVisuals()
        
//        if let address = event?.address {
//            addAddressPin(address.town)
//        }
    }
    
    func initVisuals() {
        titleSection.set(title: event!.name, subtitle: Commons.getStringFromDate(date: event!.date, format: "dd MMMM YYYY").uppercased())
        set(imgUrl: event!.imgUrl)
        set(price: event!.price)
        set(organizer: event!.organizer)
        set(address: event!.address)
        descriptionSection.set(title: "Descripció", body: event!.description)
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
        set(organizerImgUrl: organizer.imgUrl)
        socialBar.setUrls(twitter: organizer.twitterUrl, facebook: organizer.facebookUrl, instagram: organizer.instagramUrl, web: organizer.webUrl)
        observeSocialButtons()
    }
    
    func observeSocialButtons() {
        socialBar.twitterButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.event!.organizer.twitterUrl)
            })
            .addDisposableTo(disposeBag)
        
        socialBar.facebookButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.event!.organizer.facebookUrl)
            })
            .addDisposableTo(disposeBag)
        
        socialBar.instagramButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.event!.organizer.instagramUrl)
            })
            .addDisposableTo(disposeBag)
        
        socialBar.webButton.rx.tap
            .subscribe(onNext: { _ in
                self.open(url: self.event!.organizer.webUrl)
            })
            .addDisposableTo(disposeBag)
    }
    
    func set(organizerImgUrl: String?) {
        if let organizerImgUrl = organizerImgUrl {
            if let url = URL(string: organizerImgUrl) {
                organizerImage.kf.setImage(with: url)
            }
        }
        else {
            organizerImage.isHidden = true
        }
    }
    
    func set(address: Address?) {
        if let address = address {
            streetLabel.text = address.getTitle()
            cityPostalCodeLabel.text = address.getSubtitle()
            addAddressPin(address)
        }
    }
    
    func open(url: String?) {
        if let url = url {
            if let url = URL(string: url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToImageDisplay", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageDisplay" {
            let vc = segue.destination as! ImageDisplayViewController
            vc.imgUrl = self.event!.imgUrl
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
    
}
