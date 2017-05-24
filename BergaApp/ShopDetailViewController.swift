//
//  ShopDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 20/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var shop: Shop?
    var number = "938224060"
    let notificationsActivated = Variable<Bool>(false)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = shop?.name
        self.navigationItem.backBarButtonItem?.title = ""

        notificationsActivated.asObservable()
            .map({
                $0 ? "notifications" : "notification_none"
            })
            .subscribe(onNext: { imgName in
                self.navigationItem.rightBarButtonItem?.image = UIImage(named: imgName)
            })
            .addDisposableTo(disposeBag)
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

    @IBAction func notificationsPressed(_ sender: Any) {
        notificationsActivated.value = !notificationsActivated.value
    }

}
