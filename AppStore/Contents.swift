//
//  Contents.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 26..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class Contents: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    var appId: String = ""
    var appName: String = ""
    var copyright: String = ""
    var contentsArray: NSMutableArray = []
    var artistName: String = ""
    var screenShotUrlArray: NSArray = []
    var screenShotImageArray: NSMutableArray = []
    var SegCell: ContentsTableCell!
    var selectScreenShotIndex: Int = 0
    
    
    @IBOutlet var Indicator: UIActivityIndicatorView!
    @IBOutlet var HiddenLabel: UILabel!
    @IBOutlet var ContentsTableView: UITableView!
    @IBOutlet var AppInfoView: UIView!
    @IBOutlet var AppIconImage: AsyncImageView!
    @IBOutlet var TitleLabel: AutoFontSize!
    @IBOutlet var TrackLabel: UILabel!
    @IBOutlet var ArtistButton: UIButton!
    @IBOutlet var DownloadButton: UIButton!
    var SegMenu: UISegmentedControl?
    
    // MARK: Code
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //레이아웃 셋팅
        ContentsTableView.rowHeight = UITableViewAutomaticDimension
        ContentsTableView.estimatedRowHeight = 1000
        AppIconImage.layer.cornerRadius = AppIconImage.frame.width/4
        AppIconImage.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3).cgColor
        AppIconImage.layer.borderWidth = 1/UIScreen.main.scale
        SegCell = ContentsTableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! ContentsTableCell
        
        DownloadButton.layer.cornerRadius = 3;
        DownloadButton.layer.borderColor = UIColor.init(r: 0, g: 122, b: 255, a: 1.0).cgColor
        DownloadButton.layer.borderWidth = 1.0
        
        //넘겨받은 APP 기본정보 출력
        TitleLabel.text = appName
        TitleLabel.autoSize(fontSize: 13.5)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)&country=kr")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let results = ((json.object(forKey: "results")as! NSArray) [0]) as! NSDictionary
                    let appIconUrl: String = results["artworkUrl512"] as! String
                    self.AppIconImage.loadImage(urlString: appIconUrl)
                    
                    self.screenShotUrlArray = results["screenshotUrls"] as! NSArray
                    self.contentsArray.add(["type" : 0, "contents" : (results["screenshotUrls"])!, "subTitle" : "iPhone"] as NSMutableDictionary)
                    self.contentsArray.add(["type" : 1, "contents" : (results["description"])!,"subTitle" : "설명", "spread" : false, "spreadMaxHeight" : 0 as CGFloat] as NSMutableDictionary)
                    self.contentsArray.add(["type" : 2, "contents" : (results["releaseNotes"])!, "updateString": (results["currentVersionReleaseDate"])!, "subTitle" : "새로운 기능", "spread" : false, "spreadMaxHeight" : 0 as CGFloat] as NSMutableDictionary)
                    
                    //앱정보 type:3
                    self.contentsArray.add(["type" : 4, "contents" : "버전 업데이트 기록"] as NSMutableDictionary)
                    if let siteUrl: String = results["sellerUrl"] as? String {
                        self.contentsArray.add(["type" : 5, "contents" : "개발자 웹사이트", "url" :siteUrl] as NSMutableDictionary)
                    }
                    
                    if let sellerUrl: String = results["siteUrl"] as? String {
                        self.contentsArray.add(["type" : 5, "contents" : "개인정보 취급방침", "url" :sellerUrl] as NSMutableDictionary) // 개인정보 취급방침 url 데이터 없음
                    }
                    self.contentsArray.add(["type" : 4, "contents" : "개발자 앱"] as NSMutableDictionary)
                    self.contentsArray.add(["type" : 6, "contents" : "개발자 앱"] as NSMutableDictionary)
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        if let track: String = results["trackContentRating"] as? String {
                            self.TrackLabel.text = " \(track) "
                            self.TrackLabel.layer.borderColor = UIColor.init(r: 99, g: 99, b: 99, a: 1.0).cgColor
                            self.TrackLabel.layer.borderWidth = 1
                        }
                        self.artistName = results["artistName"] as! String
                        self.ArtistButton.setTitle("\(self.artistName) >", for: .normal)
                        self.downloadAppImage()
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    func downloadAppImage() {
        print("이미지 다운로드")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for i in 0..<(screenShotUrlArray.count) {
            let url = URL(string: screenShotUrlArray[i] as! String)
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }else{
                    if let image = UIImage(data: data!) {
                        self.screenShotImageArray.add(image)
                        if i == (self.screenShotUrlArray.count)-1 {//마지막 까지 완료가 되었으면
                            DispatchQueue.main.async {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.Indicator.stopAnimating()
                                self.Indicator.isHidden = true
                                self.ContentsTableView.delegate = self
                                self.ContentsTableView.dataSource = self
                                self.ContentsTableView.reloadData()
                                self.ContentsTableView.isHidden = false
                                
                                let border = CALayer()
                                let borderWidth = 1/UIScreen.main.scale
                                border.frame = CGRect.init(x: 0, y: 50 - borderWidth, width: self.view.frame.width, height: borderWidth)
                                border.backgroundColor = UIColor.init(r: 200, g: 199, b: 204, a: 1.0).cgColor
                                self.SegCell.layer.addSublayer(border)
                            }
                        }
                    }
                }
            }).resume()
        }
    }
    
    
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return SegCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentsArray.count)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic: NSMutableDictionary = contentsArray[indexPath.row] as! NSMutableDictionary
        let type: Int = dic["type"] as! Int
        if type == 0 { //스크린샷
            let screenShot: NSArray = dic["contents"] as! NSArray
            if screenShot.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScreenShot", for: indexPath ) as! ContentsTableCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath ) as! ContentsTableCell
                return cell
            }
            
        }else if type == 1 || type == 2{ //앱 소개
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath ) as! ContentsTableCell
            var contents: String = ""
            if let update: String = dic["updateString"] as? String {
                let index = update.index(update.startIndex, offsetBy: 10)
                let text: String = update.substring(to: index)
                contents = "\(text)\n\n"
            }
            let text: String = dic["contents"] as! String
            contents = "\(contents)\(text)"
            cell.ContentsLabel.text = contents
            
            if dic["spreadMaxHeight"] as? CGFloat != 0 {
                cell.ContentsLabel.numberOfLines = 0
            }
            
            let subTitle: String = dic["subTitle"] as! String
            cell.ContentsSubTitleLabel.text = subTitle
            return cell
            
        }else if type == 3 { //앱 정보
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfo", for: indexPath ) as! ContentsTableCell
            return cell
            
        }else if type == 4 { //디테일 메뉴
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMenu", for: indexPath ) as! ContentsTableCell
            let str: String = dic["contents"] as! String
            cell.ContentsLabel.text = str
            return cell
            
        }else if type == 5 { //URL 메뉴
            let cell = tableView.dequeueReusableCell(withIdentifier: "UrlMenu", for: indexPath ) as! ContentsTableCell
            let str: String = dic["contents"] as! String
            cell.ContentsLabel.text = str
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Copyright", for: indexPath ) as! ContentsTableCell
            cell.ContentsLabel.text = copyright
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //셀렉트 효과 걷어내는 부분 (appStore에 없는 효과라 비활성화)
        let dic: NSMutableDictionary = contentsArray[indexPath.row] as! NSMutableDictionary
        let type: Int = dic["type"] as! Int
        if type == 1 || type == 2 {
            if !(dic["spread"] as! Bool) {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    let maxHeight: CGFloat = self.HiddenLabel.frame.height
                    dic.setObject(maxHeight, forKey: "spreadMaxHeight" as NSCopying)
                    tableView.reloadData()
                    
                }
                dic.setObject(true, forKey: "spread" as NSCopying) //spread 부분을 조정해서 펼치기 상태로 변경
                let str: String = dic["contents"] as! String
                HiddenLabel.text = str
                CATransaction.commit()
            }
        } else if type == 5 { //URL 메뉴
            let urlString: String = dic["url"] as! String
            let url = URL(string: urlString)
            UIApplication.shared.openURL(url!) //Safari 이동
       }
    }

    
// MARK: Collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (screenShotImageArray.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScreenShotCollection
        let image: UIImage = (screenShotImageArray[indexPath.row] as? UIImage)!
        Cell.ScreenShotImageButton.setImage(image, for: .normal)
        Cell.ScreenShotImageButton.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3).cgColor
        Cell.ScreenShotImageButton.layer.borderWidth = 1/UIScreen.main.scale
        Cell.ScreenShotImageButton.tag = indexPath.row
        return Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScreenShotCollection
        Cell.ScreenShotImageButton.setImage(nil, for: .normal)
    }
    
    @IBAction func SelectScreenShotEvent(_ sender: UIButton) {
        selectScreenShotIndex = sender.tag
        performSegue(withIdentifier: "screenShot", sender: sender)
    }
    
    // MARK: SegmentControl
    @IBAction func ContentsSegmentControlEvent(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //세부사항
            print("세부사항 로드")
            
        case 1: // 리뷰
            print("리뷰 로드")
            
        case 2: // 관련콘텐츠
            print("관련 콘텐츠 로드")
            
        default:
            break
        }
    }
    
    
    // MARK: Etc
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == ContentsTableView {
            let offSetY = scrollView.contentOffset.y
            if offSetY <= AppInfoView.frame.height - 64 {
                SegCell.ContentsSegmentBgView.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, a: 1.0)
                
            }else {
                SegCell.ContentsSegmentBgView.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detail") {
            let VC = segue.destination as! Detail
            VC.subTitle = artistName
        }
        
        if(segue.identifier == "screenShot") {
            let VC = segue.destination as! PreViewController
            VC.page = selectScreenShotIndex
            VC.preViewArray = screenShotImageArray;
        }
    }
    
}


class ContentsTableCell: UITableViewCell {
    @IBOutlet var ContentsSegmentBgView: UIView!
    @IBOutlet var ContentsSegmentControl: UISegmentedControl!
    @IBOutlet var ContentsScreenShotCollectionView: UICollectionView!
    @IBOutlet var ContentsSubTitleLabel: UILabel!
    @IBOutlet var ContentsLabel: UILabel!
}

class ScreenShotCollection: UICollectionViewCell {
    @IBOutlet var ScreenShotImageButton: UIButton!
}
