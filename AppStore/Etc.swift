//
//  extension.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 31..
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

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

class AsyncImageView: UIImageView {
    func loadImage(urlString: String){
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print("some error!")
            } else {
                if let bach = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        self.image = bach
                    }
                }
            }
        })
        task.resume()
    }
}

class AutoFontSize: UILabel {
    
    func autoSize(fontSize: CGFloat) {
        let newFontSize: CGFloat =  CGFloat(UIScreen.main.bounds.size.height * (fontSize / 568.0))
        self.font = self.font.withSize(newFontSize)
    }
}
