//
//  DetailViewModel.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 17..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation

class DetailViewModel: NetworkProtocol {
    
    var previewItems:[String]?
    
    var isLoading: Dynamic<Bool> = Dynamic(false)
    var title: Dynamic<String> = Dynamic("")
    var artist: Dynamic<String> = Dynamic("")
    var item: Dynamic<[DetailViewModelItem]> = Dynamic([])
    var appIconUrl: Dynamic<String> = Dynamic("")
    var advisoryRating: Dynamic<String> = Dynamic("0+")
    var ratingCount: Dynamic<String> = Dynamic("(0)")
    var ratingPercent: Dynamic<Double> = Dynamic(0.01)
    
    func loadData(by appData: ListViewModelItem?) {
        guard let data = appData else { return }
        
        isLoading.value = true
        title.value = data.title
        artist.value = data.artist + ">"
        
        let urlStr = "https://itunes.apple.com/lookup?id=\(data.appId)&country=kr"
        getJSON(urlString: urlStr) { [weak self] in
            guard
                let results: Results = self?.jsonParse($0),
                var detailData = results.results.first
            else {
                return
            }
            
            self?.appIconUrl.value = detailData.artworkUrl100 ?? ""
            self?.advisoryRating.value = detailData.contentAdvisoryRating ?? ""
            self?.ratingCount.value = self?.setRatingCount(for: detailData) ?? "(0)"
            self?.ratingPercent.value = self?.setRating(for: detailData) ?? 0.01
            detailData.copyright = data.copyright
            
            
            var tempItems:[DetailViewModelItem] = []
            
            if let screenshotUrls = detailData.screenshotUrls {
                let item = PreView(title: "iPhone", urls: screenshotUrls)
                tempItems.append(item)
                self?.previewItems = item.urls
            }
            
            if let description = detailData.description {
                let item = Desc(title: "내용", date: nil, text: description)
                tempItems.append(item)
            }
            
            if let releaseNotes = detailData.releaseNotes,
                let date = detailData.currentVersionReleaseDate {
                let item = Desc(title: "새로운 내용", date: date, text: releaseNotes)
                tempItems.append(item)
            }
            
            if let name = detailData.sellerName,
                let genres = detailData.genres,
                let releaseDate = detailData.currentVersionReleaseDate,
                let version = detailData.version,
                let fileSize = detailData.fileSizeBytes,
                let contentsRating = detailData.contentAdvisoryRating,
                let minimumOs = detailData.minimumOsVersion,
                let devices = detailData.supportedDevices,
                let language = detailData.languageCodesISO2A {
                let item = Info(title: "정보", name: name, genres: genres, releaseDate: releaseDate, version: version, fileSize: fileSize, contentsRating: contentsRating, minimumOs: minimumOs, devices: devices, language: language)
                tempItems.append(item)
            }
            
            if let url = detailData.sellerUrl {
                let item = Link(title: "개발자 웹사이트", url: url)
                tempItems.append(item)
            }
            
            if let copyright = data.copyright {
                let item = Copyright(title: copyright)
                tempItems.append(item)
            }
            
            self?.item.value = tempItems
            self?.isLoading.value = false
        }
    }
    
    fileprivate func setRatingCount(for data: AppDetailDataModel) -> String {
        guard let count = data.userRatingCountForCurrentVersion else { return "(0)" }
        return "(\(count))"
    }
    
    fileprivate func setRating(for data: AppDetailDataModel) -> Double {
        guard let average = data.averageUserRatingForCurrentVersion else { return 0.01 }
        let percent = average / 5.0
        return percent
    }
}



