//
//  AppListTableViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 9. 12..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class AppListTableViewCell: UITableViewCell {
    
    @IBOutlet var RankLabelWidth: NSLayoutConstraint!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var appImage: AsyncImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var buyButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
        titleLabel.text = nil
        appImage.image = nil
    }
    
    enum iconSize: Int {
        case small = 0
        case medium
        case large
    }
    
    func configure(withDataSource dataSource: ListViewModelItem, rank: Int) {
        guard let item = dataSource as? AppListDataModel else { return }
        
        //랭크
        rankLabel.text = "\(rank)"
        rankLabel.isHidden = false
        RankLabelWidth.constant = 43
        
        //App 아이콘
        appImage.layer.cornerRadius = appImage.frame.width/4
        appImage.layer.borderColor = UIColor.init(r: 0, g: 0, b: 255, a: 0.3).cgColor
        appImage.layer.borderWidth = 1/UIScreen.main.scale
        appImage.loadImage(urlString: item.iconUrls[iconSize.medium.rawValue])
        
        //이름 + 카테고리 + 평점
        titleLabel.text = item.title
        categoryLabel.text = item.category
        
        //다운로드 버튼
        buyButton.layer.cornerRadius = 3;
        buyButton.layer.borderColor = UIColor.init(r: 0, g: 122, b: 255, a: 1.0).cgColor
        buyButton.layer.borderWidth = 1.0
        buyButton.setTitle(item.price, for: .normal)
    }
}

