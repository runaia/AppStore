//
//  CopyrightTableViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 9..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class CopyrightTableViewCell: UITableViewCell, DetailViewCellProtocol {
    
    @IBOutlet var titleLabel: UILabel!
    
    func configure(withDataSource dataSource: DetailViewModelItem) {
        guard let item = dataSource as? Copyright else { return }
        titleLabel.text = item.title
    }
    
}
