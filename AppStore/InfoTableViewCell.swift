//
//  InfoTableViewCell.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 7..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell, DetailViewCellProtocol {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sellerNameLabel: UILabel! //판매자 sellerName
    @IBOutlet var genresLabel: UILabel! //카테고리 genres
    @IBOutlet var updateLabel: UILabel! //업데이트 currentVersionReleaseDate
    @IBOutlet var versionLabel: UILabel! //버전 version
    @IBOutlet var fileSizeLabel: UILabel! //크기 fileSizeBytes
    @IBOutlet var advisoryRatingLabel: UILabel! //등급 contentAdvisoryRating
    @IBOutlet var deviceLabel: UILabel! //호환성 minimumOsVersion, supportedDevices
    @IBOutlet var languageLabel: UILabel! //언어 languageCodesISO2A
    
    func configure(withDataSource dataSource: DetailViewModelItem) {
        guard let item = dataSource as? Info else { return }
        
        titleLabel.text = item.title
        sellerNameLabel.text = item.name
        genresLabel.text = transformIntoSentence(item.genres)
        updateLabel.text = transformDate(item.releaseDate)
        versionLabel.text = item.version
        fileSizeLabel.text = transformByteToMb(item.fileSize)
        advisoryRatingLabel.text = item.contentsRating
        deviceLabel.text = self.supportDevice(deviceArray: item.devices, minimumOs: item.minimumOs)
        languageLabel.text = transformIntoSentence(item.language)
    }
    
    fileprivate func transformDate(_ dateStr: String?) -> String {
        guard let dateStr = dateStr else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStr)
        
        dateFormatter.dateFormat = "yyyy. M. d"
        let dateString = dateFormatter.string(from: date!)
        
        return dateString
    }
    
    fileprivate func transformByteToMb(_ byte: String?) -> String {
        guard
            let byte = byte,
            let size = Int64(byte) else { return "??MB" }
        let fileSize = ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
        return fileSize
    }

    fileprivate func transformIntoSentence(_ array: [String]?) -> String {
        guard var array = array else { return "" }
        
        for (index,language) in array.enumerated() {
            array[index] = language.localized
        }
        
        return array.reduce("", {$0 == "" ? $1 : $0 + ", " + $1})
    }
    
    fileprivate func supportDevice(deviceArray:[String]?, minimumOs:String?) -> String {
        guard let minimumVersion = minimumOs else { return "" }
        var suppout = "iOS " + minimumVersion + " 버전 이상이 필요."
        
        guard let device = deviceArray else { return suppout }
        let supportDeviceString = transformIntoSentence(device)
        if supportDeviceString.range(of:"iPhone") != nil { suppout += "iPhone" }
        if supportDeviceString.range(of:"iPad") != nil { suppout += ", iPad" }
        if supportDeviceString.range(of:"iPodTouch") != nil { suppout += "및 iPod touch" }
        suppout += "와(과) 호환."
        return suppout
    }
    
}

