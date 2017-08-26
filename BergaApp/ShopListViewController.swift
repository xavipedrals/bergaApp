//
//  ShopListViewController.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 18/05/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//class ShopListViewController: UIViewController {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchBackground: UIView!
//    
//    var cellWidth: Double?
//    var selectedShop: Shop?
//    let shopListViewModel = ShopListViewModel()
//    let dataSource = RxCollectionViewSectionedReloadDataSource<ShopSection>()
//    let disposeBag = DisposeBag()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        createCollectionCells()
//        createCollectionHeaders()
//        createSearchBar()
//        
//        collectionView.rx.setDelegate(self)
//            .addDisposableTo(disposeBag)
//        
//    }
//    
//    func createCollectionCells() {
//        shopListViewModel.sections.asObservable()
//            .bind(to: collectionView.rx.items(dataSource: dataSource))
//            .addDisposableTo(disposeBag)
//        
//        dataSource.configureCell = { ds, cv, indexPath, item in
//            if item.isPromoted {
//                let cell = cv.dequeueReusableCell(withReuseIdentifier: "promotedShopCell", for: indexPath) as! PromotedShopCollectionViewCell
//                cell.initCell(from: item)
//                return cell
//            }
//            else {
//                let cell = cv.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! ShopCollectionViewCell
//                cell.initCell(from: item)
//                return cell
//            }
//        }
//        
//        collectionView.rx.modelSelected(Shop.self)
//            .subscribe(onNext: { shop in
//                self.selectedShop = shop
//                self.performSegue(withIdentifier: "goToShopDetail", sender: nil)
//            })
//            .addDisposableTo(disposeBag)
//    }
//    
//    func createCollectionHeaders() {
//        dataSource.supplementaryViewFactory = { ds, cv, kind, indexPath in
//            let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shopHeader", for: indexPath) as! SectionHeaderCollectionReusableView
//            
//            header.initHeader(title: ds[indexPath.section].header)
//            return header
//        }
//    }
//
//    func createSearchBar() {
//        searchBar.rx.cancelButtonClicked
//            .subscribe(onNext: { _ in
//                self.searchBar.resignFirstResponder()
//            })
//            .addDisposableTo(disposeBag)
//        
//        searchBar.rx.text.orEmpty
//            .bind(to: self.shopListViewModel.searchString)
//            .addDisposableTo(disposeBag)
//        
//        searchBar.rx.searchButtonClicked
//            .subscribe(onNext: { _ in
//                self.searchBar.resignFirstResponder()
//            })
//            .addDisposableTo(disposeBag)
//        
//        searchBar.rx.textDidBeginEditing
//            .subscribe(onNext: {
//                self.searchBar.setShowsCancelButton(true, animated: true)
//                self.searchBackground.alpha = 0
//                self.searchBackground.isHidden = false
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.searchBackground.alpha = 0.5
//                })
//            })
//            .addDisposableTo(disposeBag)
//        
//        searchBar.rx.textDidEndEditing
//            .subscribe(onNext: {
//                self.searchBar.setShowsCancelButton(false, animated: true)
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.searchBackground.alpha = 0
//                }, completion: { _ in
//                    self.searchBackground.isHidden = true
//                })
//            })
//            .addDisposableTo(disposeBag)
//    }
//    
//    func hideKeyboard() {
//        self.view.endEditing(true)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToShopDetail" {
//            let vc = segue.destination as! ShopDetailViewController
//            vc.shop = selectedShop
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }
//
//}
//
//extension ShopListViewController: UICollectionViewDelegateFlowLayout {
//    
//    override func viewDidLayoutSubviews() {
//        setCellWidth()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellWidth!, height: 44)
//    }
//    
//    func setCellWidth () {
//        let flow: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let width = (collectionView.frame.size.width - (flow.sectionInset.right + flow.sectionInset.left) * 2)
//        cellWidth = Double(width)
//    }
//}
