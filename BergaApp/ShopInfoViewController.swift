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

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var townAddressLabel: UILabel!
    
    @IBOutlet weak var descriptionWrapper: UIView!
    @IBOutlet weak var phoneWrapper: UIView!
    @IBOutlet weak var scheduleWrapper: UIView!
    @IBOutlet weak var imageCarruselWrapper: UIView!
    @IBOutlet weak var linkWrapper: UIView!
    @IBOutlet weak var mapWrapper: UIView!
    @IBOutlet weak var promoteShopWrapper: UIView!
    
    
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
        shopDetailViewModel!.shop.asObservable()
            .subscribe(onNext: { shop in
                self.initVisuals(shop: shop)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func initVisuals(shop: Shop) {
        set(name: shop.name)
        set(description: shop.description)
        set(phone: shop.phone)
        set(schedule: shop.schedule)
        set(url: shop.url)
        set(address: shop.address)
        set(isPromoted: shop.isPromoted)
    }
    
    func set(name: String) {
        shopNameLabel.attributedText = Commons.getAttributedCharSpacedText(name.uppercased(), charSpacing: 1.15)
    }
    
    func set(description: String) {
        self.descriptionLabel.attributedText = Commons.getAttributedLineSpaceText(description, lineSpacing: 5)
    }
    
    func set(phone: Int?) {
        if let phone = phone {
            phoneLabel.text = getPhoneString(phone)
        }
        else {
            phoneWrapper.isHidden = true
        }
    }
    
    func set(schedule: String?) {
        if let schedule = schedule {
            self.scheduleLabel.attributedText = Commons.getAttributedLineSpaceText(schedule, lineSpacing: 5)
        }
        else {
            scheduleWrapper.isHidden = true
        }
    }
    
    func set(url: String?) {
        if let url = url {
            urlLabel.text = url
        }
        else {
            linkWrapper.isHidden = true
        }
    }
    
    func set(address: String?) {
        if let address = address {
            addAddressPin(address)
            streetAddressLabel.text = address
        }
        else {
            mapWrapper.isHidden = true
        }
    }
    
    func set(isPromoted: Bool) {
        imageCarruselWrapper.isHidden = !isPromoted
        promoteShopWrapper.isHidden = isPromoted
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

    @IBAction func callPressed(_ sender: Any) {
        if let number = shopDetailViewModel!.shop.value.phone {
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
        if let url = shopDetailViewModel!.shop.value.url {
            if let urlFormated = URL(string: url) {
                UIApplication.shared.openURL(urlFormated)
            }
        }
    }

}

extension ShopInfoViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: cellWidth! / 1.75)
    }
    
    func setCellWidth () {
        let flow: UICollectionViewFlowLayout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (photosCollectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) * 2)
        cellWidth = Double(width)
    }
}

