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

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var townAddressLabel: UILabel!
    @IBOutlet weak var titleSectionView: TitleSectionView!
    @IBOutlet weak var descriptionSectionView: TextSectionView!
    
    @IBOutlet weak var descriptionWrapper: UIView!
    @IBOutlet weak var scheduleWrapper: UIView!
    @IBOutlet weak var imageCarruselWrapper: UIView!
    @IBOutlet weak var linkWrapper: UIView!
    @IBOutlet weak var mapWrapper: UIView!
    @IBOutlet weak var promoteShopWrapper: UIView!
    @IBOutlet weak var addressWrapper: UIView!

    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(10)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    var currentItem = 0
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
        set(name: shop.name, tags: shop.tags)
        set(description: shop.description)
        set(phone: shop.phone)
        set(schedule: shop.schedule)
        set(url: shop.url)
        set(address: shop.address)
        set(isPromoted: shop.isPromoted)
    }
    
    func set(name: String, tags: [String]?) {
        var tagsText = ""
        if let tags = tags {
            tagsText = tags.joined(separator: ", ")
        }
        else {
            tagsText = "Negoci no promocionat"
        }
        titleSectionView.set(title: name, subtitle: tagsText.uppercased())
    }
    
    func set(description: String) {
//        self.descriptionLabel.attributedText = Commons.getAttributedLineSpaceText(description, lineSpacing: 5)
        descriptionSectionView.set(title: "Descripció", body: description)
    }
    
    func set(phone: Int?) {
        if let phone = phone {
            phoneLabel.text = getPhoneString(phone)
        }
        else {
            phoneLabel.text = "Telèfon no disponible"
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
    
    func set(address: Address?) {
        if let address = address {
            addAddressPin(address)
            streetAddressLabel.text = address.street ?? address.town
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
        setupCollectionLayout()
        
        shopDetailViewModel!.photosUrl.asObservable()
            .bind(to: photosCollectionView.rx.items(cellIdentifier: "shopPhotoCell", cellType: ShopPhotoCollectionViewCell.self)) {
                _, url, cell in
                cell.initCell(url: url)
            }
            .addDisposableTo(disposeBag)
    }
    
    func setupCollectionLayout() {
        setCollectionItemSize()
        let layout = getCollectionLayout()
        photosCollectionView!.collectionViewLayout = layout
        photosCollectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func setCollectionItemSize() {
        cellWidth =  UIScreen.main.bounds.width - 40
        cellHeight = UIScreen.main.bounds.width * 0.8
    }
    
    func getCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: 20, height: 0)
        layout.footerReferenceSize = CGSize(width: 20, height: 0)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
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
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ShopInfoViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        setCellWidth()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth * 0.8)
    }
    
    func setCellWidth () {
        cellWidth =  UIScreen.main.bounds.width - 40
    }
}

extension ShopInfoViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(cellWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(photosCollectionView!.contentSize.width)
        
        var newPage = Float(currentItem)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        }
        else {
            newPage = Float(velocity.x > 0 ? currentItem + 1 : currentItem - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        currentItem = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    
}



