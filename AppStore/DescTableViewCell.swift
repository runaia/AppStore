//
//  DescTableViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 7..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class DescTableViewCell: UITableViewCell, DetailViewCellProtocol {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    
    func configure(withDataSource dataSource: DetailViewModelItem) {
        guard let item = dataSource as? Desc else { return }
        
        titleLabel.text = item.title
        
        var text = ""
        if let date = item.date {
            text += "\(date.date)\n\n"
        }
        text += item.text
        contentsLabel.text = text
        
        if item.expand { contentsLabel.numberOfLines = 0 }
        else { contentsLabel.numberOfLines = 5 }
    }
}
