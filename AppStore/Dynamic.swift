//
//  Dynamic.swift
//  AppStore
//
//  Created by seojiwon on 2017. 11. 20..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}
