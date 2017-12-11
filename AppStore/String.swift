//
//  String.swift
//  AppStore
//
//  Created by seojiwon on 2017. 12. 8..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy. MM. dd"

        if let date = dateFormatter.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }else{
            return self
        }
    }
}
