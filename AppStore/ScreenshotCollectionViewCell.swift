//
//  ScreenshotCollectionViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 9. 16..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageButton: AsyncButton!
    
    func configure(withURL url: String, tag: Int) {
        imageButton.loadImage(urlString: url)
        imageButton.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3).cgColor
        imageButton.layer.borderWidth = 1/UIScreen.main.scale
        imageButton.tag = tag
    }
    
}
