//
//  PreviewViewModel.swift
//  AppStore
//
//  Created by seojiwon on 2017. 12. 4..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class PreviewViewModel: UITableViewCell {
    typealias Point = (point: CGPoint, animated:Bool)
    
    var item: Dynamic<[String]> = Dynamic([])
    var numberOfPages: Dynamic<Int> = Dynamic(0)
    var currentPage: Dynamic<Int> = Dynamic(0)
    var scrollToPoint: Dynamic<Point> = Dynamic((CGPoint(x:0.0, y:0.0), false))
    
    func loadData(data: [String]) {
        numberOfPages.value = data.count
        item.value = data
    }
    
    func indexScroll (collectionView: UICollectionView , index: Int, animated: Bool) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let pointX = (layout.itemSize.width + layout.minimumLineSpacing) * CGFloat(index) - collectionView.contentInset.left
        scrollToPoint.value = Point(CGPoint(x:pointX, y:0.0), animated)
        currentPage.value = index
    }
}
