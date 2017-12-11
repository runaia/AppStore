//
//  Network.swift
//  AppStore
//
//  Created by seojiwon on 2017. 9. 22..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

protocol NetworkProtocol {
    func getJSON(urlString: String, completion: @escaping (Data) -> Void)
    func jsonParse<T: Decodable>(_ data: Data) -> T?
}

extension NetworkProtocol {
    func getJSON(urlString: String, completion: @escaping (Data) -> Void) {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
        
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0 )

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(data)
            }
            
        }.resume()
    }
    
    
    func jsonParse<T: Decodable>(_ data: Data) -> T? {
        do{
            let decoder = JSONDecoder()
            let value = try decoder.decode(T.self, from: data)
            return value
            
        } catch {
            print("jSone Parse Error")
            return nil
        }
    }
}

