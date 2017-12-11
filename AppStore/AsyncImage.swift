//
//  AsyncImage.swift
//  AppStore
//
//  Created by seojiwon on 2017. 12. 8..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

protocol AsyncImage {
    var imageUrlString: String? { get }
    func download(urlStr: String?, completion: @escaping (UIImage?) -> Void)
    func loadImage(urlString: String?)
}

extension AsyncImage {
    func download(urlStr: String?, completion: @escaping (UIImage?) -> Void) {
        guard
            let urlString = urlStr,
            let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error != nil {
                    print("이미지 다운로드 실패")
                    return
                    
                } else {
                    completion(UIImage(data: data!))
                }
            }
        }).resume()
    }
}

class AsyncImageView: UIImageView, AsyncImage {
    var imageUrlString: String?
    
    func loadImage(urlString: String?) {
        imageUrlString = urlString
        image = nil
        self.download(urlStr: urlString) { [weak self] in self?.image = $0 }
    }
}

class AsyncButton: UIButton, AsyncImage {
    var imageUrlString: String?
    
    func loadImage(urlString: String?) {
        imageUrlString = urlString
        self.setImage(nil, for: .normal)
        self.download(urlStr: urlString) { [weak self] in self?.setImage($0, for: .normal) }
    }
}

