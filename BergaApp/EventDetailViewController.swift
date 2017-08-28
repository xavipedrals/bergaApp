//
//  EventDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 16/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class EventDetailViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var organizerImage: UIImageView!
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterContainer: UIView!
    @IBOutlet weak var titleSection: TitleSectionView!
    @IBOutlet weak var descriptionSection: TextSectionView!
    @IBOutlet weak var socialBar: SocialBarView!
    @IBOutlet weak var mapSectionView: MapSectionView!
    
    var event: CalendarEvent?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVisuals()
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
        priceLabel.text = price ?? "Esdeveniment gratuït"
    }
    
    func set(organizer: EventOrganizer) {
        organizerLabel.text = organizer.name
        set(organizerImgUrl: organizer.imgUrl)
        socialBar.setUrls(twitter: organizer.twitterUrl, facebook: organizer.facebookUrl, instagram: organizer.instagramUrl, web: organizer.webUrl)
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
            mapSectionView.set(address: address)
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
}
