//
//  ListDataModelswift
//  AppStore
//
//  Created by seojiwon on 2017. 9. 22..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation

protocol ListViewModelItem {
    var iconUrls: [String?] { get } //앱 이미지 url
    var artist: String { get } //개발자
    var title: String { get } //앱 이름
    var category: String { get } //앱 카테고리
    var appId: String { get } //앱 id
    var copyright: String? { get } //카피라이트
    var price: String { get } //가격
}

struct Feed : Decodable {
    var entry: [AppListDataModel]
    
    enum CodingKeys: String, CodingKey {
        case feed
        case entry
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let feed = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
        entry = try feed.decode([AppListDataModel].self, forKey: .entry)
    }
}


struct AppListDataModel : Decodable, ListViewModelItem {
    var iconUrls: [String?] //앱 이미지 url
    var artist: String
    var title: String //앱 이름
    var category: String //앱 카테고리
    var appId: String //앱 id
    var copyright: String? //카피라이트
    var price: String //가격
    
    struct urlContainor: Decodable {
        var label: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case urls = "im:image"
        case artist = "im:artist"
        case title = "im:name"
        case category
        case appId = "id"
        case id = "im:id"
        case copyright = "rights"
        case price = "im:price"
        
        case attributes
        case label
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let urlsContainer = try values.decode([urlContainor].self, forKey: .urls)
        iconUrls = urlsContainer.map{$0.label}
        
        let artistContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .artist)
        artist = try artistContainer.decode(String.self, forKey: .label)
        
        let titleContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .title)
        title = try titleContainer.decode(String.self, forKey: .label)
        
        let categoryContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .category)
        let attributesContainer = try categoryContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        category = try attributesContainer.decode(String.self, forKey: .label)
        
        let appIdContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .appId)
        let idContainer = try appIdContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        appId = try idContainer.decode(String.self, forKey: .id)
        
        let copyrightContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .copyright)
        copyright = try copyrightContainer.decode(String.self, forKey: .label)
        
        let priceContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .price)
        price = try priceContainer.decode(String.self, forKey: .label)
    }
}
