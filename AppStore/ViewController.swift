//
//  ViewController.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 25..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Object
    var listArray: NSMutableArray = []
    var copyright: String!
    @IBOutlet var ListTableView: UITableView!
    @IBOutlet var Indicator: UIActivityIndicatorView!
    
    // MARK: Code
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/genre=6015/json")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }else{
                if  let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    if let feed = (json!.object(forKey: "feed") as! NSDictionary)["entry"]as? NSArray{
                            for i in feed {
                                if let item = i as? NSDictionary {
                                    var urlString: String = ""
                                    if UIScreen.main.scale ==  1.0 {
                                        urlString = ((item["im:image"] as! NSArray)[0] as! NSDictionary)["label"] as! String
                                    }else if UIScreen.main.scale ==  2.0 {
                                        urlString = ((item["im:image"] as! NSArray)[1] as! NSDictionary)["label"] as! String
                                    }else {
                                        urlString = ((item["im:image"] as! NSArray)[2] as! NSDictionary)["label"] as! String
                                    }
                                    
                                    let title: String = (item["im:name"] as! NSDictionary)["label"] as! String
                                    let category: String = ((item["category"] as! NSDictionary) ["attributes"] as! NSDictionary) ["label"] as! String
                                    let appId: String = ((item["id"] as! NSDictionary)["attributes"] as! NSDictionary)["im:id"] as! String
                                    self.copyright = (item["rights"] as! NSDictionary)["label"] as! String
                                    
                                    let itemDic: NSMutableDictionary = ["urlString":urlString, "title":title, "category":category, "appId":appId]
                                    self.listArray.add(itemDic)
                                    
                                }
                            }
                    }
                }
                
                DispatchQueue.main.async {
                    print("데이터 다운 :", self.listArray.count, "개\n")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.downloadAppImage()
                }
            }
        }).resume()
    }
    
    func downloadAppImage() {
        print("이미지 \(listArray.count)개 다운로드 시작")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for i in 0..<(listArray.count) {
            let item = self.listArray[i] as! NSDictionary
            let url = URL(string: item["urlString"] as! String)
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }else{
                    if let image = UIImage(data: data!) {
                        item.setValue(image, forKey: "image")
                        if i == (self.listArray.count)-1 {//마지막 까지 완료가 되었으면
                            DispatchQueue.main.async {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.Indicator.stopAnimating()
                                self.Indicator.isHidden = true
                                print("앱 아이콘 \(self.listArray.count)개 다운로드 완료\n")
                                self.ListTableView.delegate = self
                                self.ListTableView.dataSource = self
                                self.ListTableView.reloadData()
                                self.ListTableView.isHidden = false
                            }
                        }
                    }
                }
            }).resume()
        }
    }

    
// MARK: TableView
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath ) as! ListCell
        let item: NSDictionary = listArray[indexPath.row] as! NSDictionary
        
        //랭크
        cell.rankLabel.text = "\(String(indexPath.row + 1))"
        
        //App 아이콘
        let image: UIImage = item["image"] as! UIImage
        cell.appImage.image = image
        cell.appImage.layer.cornerRadius = cell.appImage.frame.width/4
        cell.appImage.layer.borderColor = UIColor.init(r: 0, g: 0, b: 255, a: 0.3).cgColor
        cell.appImage.layer.borderWidth = 1/UIScreen.main.scale
        
        //이름 + 카테고리 + 평점 (데이터 없음)
        cell.titleLabel.text = item["title"] as? String
        cell.categoryLabel.text = item["category"] as? String
        cell.titleLabel.autoSize(fontSize: 11.0)
        
        //다운로드 버튼
        cell.buyButton.layer.cornerRadius = 3;
        cell.buyButton.layer.borderColor = UIColor.init(r: 0, g: 122, b: 255, a: 1.0).cgColor
        cell.buyButton.layer.borderWidth = 1.0
        
        return cell
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectItem") {
            let VC = (segue.destination as! Contents)
            let indexPath = ListTableView.indexPathForSelectedRow
            let item: NSDictionary = self.listArray[(indexPath?.row)!] as! NSDictionary
            
            VC.appId = item["appId"] as! String
            VC.appName = item["title"] as! String
            VC.copyright = copyright
        }
    }
}


class ListCell: UITableViewCell {
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var appImage: UIImageView!
    @IBOutlet var titleLabel: AutoFontSize!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var buyButton: UIButton!
}
