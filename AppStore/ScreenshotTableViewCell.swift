//
//  PreviewTableViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 7..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class ScreenshotTableViewCell: UITableViewCell, DetailViewCellProtocol {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var previewCollectionView: UICollectionView!
    
    var screenshotImageArray = [String]()
    
    func configure(withDataSource dataSource: DetailViewModelItem) {
        guard let item = dataSource as? PreView else { return }

        titleLabel.text = item.title
        screenshotImageArray = item.urls
        
        if let layout = previewCollectionView.collectionViewLayout as? HorizontalFlowLayout {
            layout.baseLineX = layout.minimumLineSpacing + (layout.itemSize.width * 0.5)
            previewCollectionView.collectionViewLayout = layout
            previewCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        }
        
        previewCollectionView.dataSource = self
        previewCollectionView.delegate = self
        previewCollectionView.reloadData()
    }
}


extension ScreenshotTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScreenshotCollectionViewCell
        Cell.configure(withURL: screenshotImageArray[indexPath.row], tag: indexPath.row)
        return Cell
    }
}
