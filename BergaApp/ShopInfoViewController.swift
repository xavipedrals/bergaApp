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
        
    }
    
    func initVisuals(shopDetail: ShopDetail) {
        if let description = shopDetail.description {
            self.descriptionLabel.text = description
        }
        if let coordinates = shopDetail.coordinates {
            
        }
        if let phone = shopDetail.phone {
            var phoneString = String(phone)
//            phoneString.insert(" ", at: phoneString.index(phoneString.start, offsetBy: <#T##String.IndexDistance#>))
            
            phoneLabel.text = String(phone)
        }
        if let photos = shopDetail.photosUrls {
            
        }
        if let schedule = shopDetail.schedule {
            scheduleLabel.text = schedule
        }
        if let url = shopDetail.url {
//            urlLabel.text = url
        }
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

}
