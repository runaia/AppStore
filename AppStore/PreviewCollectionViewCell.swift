//
//  PreviewCollectionViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 9. 16..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: AsyncImageView!
    
    func configure(withURL url: String) {        
        imageView.loadImage(urlString: url)
        imageView.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3).cgColor
        imageView.layer.borderWidth = 1/UIScreen.main.scale
    }
    
    func selfSize() -> CGSize {
        var size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
        size.width = (size.height/self.frame.height) * size.width
        return size
    }
    
}
