//
//  CenteredCollectionViewProtocol.swift
//  BergaApp
//
//  Created by Xavier Pedrals on 29/08/2017.
//  Copyright © 2017 Xavier Pedrals. All rights reserved.
//

import UIKit

class CenteredCollectionView: UICollectionView {
    
    var collectionMargin = CGFloat(20)
    var itemSpacing = CGFloat(10)
    var cellHeight = CGFloat(0)
    var cellWidth = CGFloat(0)
    
    func setup(cellWidth: CGFloat, cellHeight: CGFloat, itemSpacing: CGFloat = 10, collectionMargin: CGFloat = 20) {
        let layout = getCollectionLayout()
        self.collectionViewLayout = layout
        self.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    private func getCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        return layout
    }    
}

class CenteredScrollManager: NSObject {

    var pageWidth: Float!
    var currentItem = 0
    
    func set(pageWidth: CGFloat) {
        self.pageWidth = Float(pageWidth)
    }
    
    func getNextItemPoint(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, collectionContentSize: CGFloat) -> CGPoint {
        let pageWidth = self.pageWidth!
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionContentSize)
        
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
        
        return point
    }
    
}
