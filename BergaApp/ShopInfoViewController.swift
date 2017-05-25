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

class ShopInfoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var urlLabel: UILabel!
    
    var cellWidth: Double?
    var shopDetailViewModel: ShopDetailViewModel?
    var shop: Shop?
    var number = "938224060"
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopDetailViewModel = ShopDetailViewModel(shop: shop!)
        
        shopDetailViewModel!.shopDetail.asObservable()
            .subscribe(onNext: { shopDetail in
                self.initVisuals(shopDetail: shopDetail)
            })
            .addDisposableTo(disposeBag)
        
        shopDetailViewModel!.photosUrl.asObservable()
            .bind(to: photosCollectionView.rx.items(cellIdentifier: "shopPhotoCell", cellType: ShopPhotoCollectionViewCell.self)) {
                _, url, cell in
                cell.initCell(url: url)
            }
            .addDisposableTo(disposeBag)
        
        photosCollectionView.rx.setDelegate(self)
        .addDisposableTo(disposeBag)
    }
    
    func initVisuals(shopDetail: ShopDetail) {
        if let description = shopDetail.description {
            self.descriptionLabel.text = description
        }
        if let coordinates = shopDetail.coordinates {
            
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

    @IBAction func callPressed(_ sender: Any) {
        callNumber(number)
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
