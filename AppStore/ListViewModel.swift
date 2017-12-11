//
//  ListViewModel.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 17..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation

class ListViewModel: NetworkProtocol {
    
    let gere = "6015"
    
    var urlStr: Dynamic<String> = Dynamic("")
    var title: Dynamic<String> = Dynamic("금융")
    var item: Dynamic<[AppListDataModel]> = Dynamic([])
    var indicatorAnimating:Dynamic<Bool> = Dynamic(false)
    var reload:Dynamic<Bool> = Dynamic(false)
    
    func loadData() {
        urlStr.value = "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/genre=\(gere)/json"
        
        reload.value = false
        indicatorAnimating.value = true
        
        getJSON(urlString: urlStr.value) { [weak self] in
            guard let feed: Feed = self?.jsonParse($0)
            else {
                self?.reload.value = true
                return
            }
            
            let entry = feed.entry
            self?.indicatorAnimating.value = false
            self?.item.value = entry
        }
    }
}



