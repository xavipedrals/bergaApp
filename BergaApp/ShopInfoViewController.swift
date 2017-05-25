//
//  ShopInfoViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 24/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class ShopInfoViewController: MapViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var urlLabel: UILabel!
    
    var cellWidth: Double?
    var shopDetailViewModel: ShopDetailViewModel?
    var shop: Shop?
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopDetailViewModel = ShopDetailViewModel(shop: shop!)
        displayInfo()
        configurePhotoCollection()
        mapView.delegate = self
        
        photosCollectionView.rx.setDelegate(self)
        .addDisposableTo(disposeBag)
        
    }
    
    private func displayInfo() {
        shopDetailViewModel!.shopDetail.asObservable()
            .subscribe(onNext: { shopDetail in
                self.initVisuals(shopDetail: shopDetail)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func initVisuals(shopDetail: ShopDetail) {
        if let description = shopDetail.description {
            self.descriptionLabel.text = description
        }
        if let phone = shopDetail.phone {
            phoneLabel.text = getPhoneString(phone)
        }
        if let schedule = shopDetail.schedule {
            scheduleLabel.text = schedule
        }
        if let url = shopDetail.url {
            urlLabel.text = url
        }
        if let address = shopDetail.address {
            addAddressPin(address)
        }
    }
    
    func configurePhotoCollection() {
        shopDetailViewModel!.photosUrl.asObservable()
            .bind(to: photosCollectionView.rx.items(cellIdentifier: "shopPhotoCell", cellType: ShopPhotoCollectionViewCell.self)) {
                _, url, cell in
                cell.initCell(url: url)
            }
            .addDisposableTo(disposeBag)
    }
    
    func getPhoneString(_ number: Int) -> String {
        var phoneStr = String(number)
        if phoneStr.length >= 9 {
            phoneStr.insert(" ", at: phoneStr.index(phoneStr.startIndex, offsetBy: 2))
            phoneStr.insert(" ", at: phoneStr.index(phoneStr.startIndex, offsetBy: 6))
            phoneStr.insert(" ", at: phoneStr.index(phoneStr.startIndex, offsetBy: 9))
        }
        return phoneStr
        
    }
    
//    func addAddressPin(_ address: String) {
//        let location = address
//        let geocoder:CLGeocoder = CLGeocoder()
//        
//        geocoder.geocodeAddressString(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) -> Void in
//            if let firstPlacemark = placemarks?.first {
//                
//                let placemark: MKPlacemark = MKPlacemark(placemark: firstPlacemark)
//                let regionRadius: CLLocationDistance = 2000
//                let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, regionRadius, regionRadius)
//                
//                self.mapView.setRegion(region, animated: true);
//                self.mapView.addAnnotation(placemark);
//                
//            }
//        })
//    }
    
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

    @IBAction func callPressed(_ sender: Any) {
        if let number = shopDetailViewModel!.shopDetail.value.phone {
            callNumber(String(number))
        }
    }
    
    private func callNumber(_ phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
    }
    
    @IBAction func linkPressed(_ sender: Any) {
        if let url = shopDetailViewModel!.shopDetail.value.url {
            if let urlFormated = URL(string: url) {
                UIApplication.shared.openURL(urlFormated)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }

}

extension ShopInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: cellWidth! * 3 / 4)
    }
    
    func setCellWidth () {
        let flow: UICollectionViewFlowLayout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (photosCollectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) * 2)
        cellWidth = Double(width)
    }
}

