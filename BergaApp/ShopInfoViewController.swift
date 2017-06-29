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
import MessageUI

class ShopInfoViewController: MapViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
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
    @IBOutlet weak var addressWrapper: UIView!
    @IBOutlet weak var dotsWrapper: UIView!
    @IBOutlet var dotViews: [UIView]!
    
    var cellWidth: Double?
    var shopDetailViewModel: ShopDetailViewModel?
    var shop: Shop?
    var selectedDotIndex = 0
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
        set(tags: shop.tags)
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
    
    func set(tags: [String]?) {
        if let tags = tags {
            let tagsText = tags.joined(separator: ", ")
            tagsLabel.text = tagsText
        }
        else {
            tagsLabel.text = "Negoci no promocionat"
        }
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
//            urlLabel.text = url
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
            addressWrapper.isHidden = true
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
        
        shopDetailViewModel!.photosUrl.asObservable()
            .map{ $0.count }
            .subscribe(onNext: { count in
                if count == 0 {
                    self.dotsWrapper.isHidden = true
                }
                else {
                    for i in count ..< 5 {
                        self.dotViews[i].isHidden = true
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        photosCollectionView.rx.didEndDecelerating
            .subscribe(onNext: { _ in
                let indexs = self.photosCollectionView.indexPathsForVisibleItems
                let index = indexs[0]
                self.dotViews[self.selectedDotIndex].backgroundColor = UIColor.darkGray
                self.dotViews[index.row].backgroundColor = Colors.green
                self.selectedDotIndex = index.row
            })
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
    
    @IBAction func promoteShopPressed(_ sender: Any) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["bergapp@gmail.com"])
        mailComposerVC.setSubject("Promocionar \(shop!.name)")
//        mailComposerVC.setMessageBody("", isHTML: false)
        self.present(mailComposerVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {        dismiss(animated: true, completion: nil)
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

