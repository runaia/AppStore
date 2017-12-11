//
//  UIColor.swift
//  AppStore
//
//  Created by seojiwon on 2017. 12. 8..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Float, g: Float, b: Float, a: Float) {
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: CGFloat(a)
        )
    }
}
