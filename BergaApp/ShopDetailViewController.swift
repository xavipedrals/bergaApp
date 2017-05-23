//
//  ShopDetailViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 20/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var shop: Shop?
    var number = "938224060"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = shop?.name
        self.navigationItem.backBarButtonItem?.title = ""

        
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
