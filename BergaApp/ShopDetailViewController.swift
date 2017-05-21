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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var shop: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = shop?.name
        self.navigationItem.backBarButtonItem?.title = ""

        
    }


}
