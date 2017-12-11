//
//  DetailDataModel.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 8..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation

struct Results : Decodable {
    var results: [AppDetailDataModel]
}

struct AppDetailDataModel: Decodable {
    var contentAdvisoryRating: String?
    var artistName: String?
    var artworkUrl100: String?
    var averageUserRatingForCurrentVersion: Double?
    var userRatingCountForCurrentVersion: Int?
    var copyright: String?
    
    var screenshotUrls: [String]?
    var description: String?
    var currentVersionReleaseDate: String?
    var releaseNotes: String?
    var sellerName: String?
    var genres: [String]?
    var version: String?
    var fileSizeBytes: String?
    var minimumOsVersion: String?
    var supportedDevices: [String]?
    var languageCodesISO2A: [String]?
    var sellerUrl: String?
}


enum DetailType {
    case preView
    case desc
    case info
    case link
    case copyright
}

protocol DetailViewModelItem {
    var type: DetailType { get }
    var title: String { get }
}

struct PreView: DetailViewModelItem {
    var type: DetailType { return .preView }
    var title: String
    var urls: [String] //스크린샷 이미지 url 배열
}

class Desc: DetailViewModelItem {
    var type: DetailType { return .desc }
    var title: String
    var date: String? //일자
    var text: String //내용
    var expand: Bool = false
    
    init (title:String, date:String?, text:String){
        self.title = title
        self.date = date
        self.text = text
    }
}

struct Info: DetailViewModelItem {
    var type: DetailType { return .info }
    var title: String
    var name: String
    var genres: [String]
    var releaseDate: String
    var version: String
    var fileSize: String
    var contentsRating: String
    var minimumOs: String
    var devices: [String]
    var language: [String]
}

struct Link: DetailViewModelItem {
    var type: DetailType { return .link }
    var title: String
    var url: String
}

struct Copyright: DetailViewModelItem {
    var type: DetailType { return .copyright }
    var title: String
}

