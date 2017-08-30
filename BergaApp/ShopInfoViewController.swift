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

class ShopInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var photosCollectionView: CenteredCollectionView!
    @IBOutlet weak var titleSectionView: TitleSectionView!
    @IBOutlet weak var descriptionSectionView: TextSectionView!
    @IBOutlet weak var scheduleSectionView: TextSectionView!
    @IBOutlet weak var socialBarView: SocialBarView!
    @IBOutlet weak var mapSectionView: MapSectionView!
    @IBOutlet weak var notificationsCollectionView: UICollectionView!
    @IBOutlet weak var phoneView: PhoneView!
    @IBOutlet weak var notificationsActionView: NotificationActionView!
    
    @IBOutlet weak var descriptionWrapper: UIView!
    @IBOutlet weak var scheduleWrapper: UIView!
    @IBOutlet weak var imageCarruselWrapper: UIView!
    @IBOutlet weak var linkWrapper: UIView!
    @IBOutlet weak var promoteShopWrapper: UIView!

    let collectionMargin = CGFloat(20)
    let itemSpacing = CGFloat(10)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    var currentItem = 0
    var shopDetailViewModel: ShopDetailViewModel?
    var centeredScrollManager = CenteredScrollManager()
    var shop: Shop?
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopDetailViewModel = ShopDetailViewModel(shop: shop!)
        displayInfo()
        configurePhotoCollection()
        notificationsActionView.set(activated: true)
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
        descriptionSectionView.set(title: "Descripció", body: description)
    }
    
    func set(phone: Int?) {
        phoneView.set(phone: phone)
    }
    
    func set(schedule: String?) {
        if let schedule = schedule {
            scheduleSectionView.set(title: "Horari", body: schedule)
        }
        else {
            scheduleWrapper.isHidden = true
        }
    }
    
    func set(url: String?) {
        if let url = url {
            socialBarView.setUrls(twitter: nil, facebook: nil, instagram: nil, web: url)
        }
        else {
            linkWrapper.isHidden = true
        }
    }
    
    func set(address: Address?) {
        if let address = address {
            mapSectionView.set(address: address)
        }
        else {
            mapSectionView.isHidden = true
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
        
        photosCollectionView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    func setupCollectionLayout() {
        setCellSize()
        photosCollectionView.setup()
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
        setCellSize()
    }
    
    func setCellSize () {
        cellWidth =  UIScreen.main.bounds.width - 40
        cellHeight = UIScreen.main.bounds.width / 1.6 - 20
        centeredScrollManager.set(pageWidth: cellWidth + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ShopInfoViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = centeredScrollManager.getNextItemPoint(velocity: velocity, targetContentOffset: targetContentOffset, collectionContentSize: photosCollectionView!.contentSize.width)
        targetContentOffset.pointee = point
    }
    
}



