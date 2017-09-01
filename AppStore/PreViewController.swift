//
//  PreViewController.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 31..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit
class PreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var preViewArray: NSArray = []
    var page: Int = 0
    var sceneSize: CGSize = CGSize(width: 0, height: 0)
    var searchScreen:Bool = true
    @IBOutlet var ScreenShotCollectionView: UICollectionView!
    @IBOutlet var DummyCollectionView: UICollectionView!
    @IBOutlet var PageControl: UIPageControl!
    
    
    
    // MARK: Code
    override func viewDidLoad() {
        super.viewDidLoad()
        print("받은 스크린샷 \(preViewArray.count)개")
        PageControl.numberOfPages = preViewArray.count// 페이지 세팅
        PageControl.currentPage =  page// 초기 페이지 세팅
        sceneSize = self.view.frame.size
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if searchScreen { //레이아웃이 완성되고 한번만 실행되도록
            searchScreen = false
            CheckInset()
//            ScreenShotCollectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            DummyCollectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (preViewArray.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == ScreenShotCollectionView {
            let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PreViewCollectionCell
            let preView: UIImage = (preViewArray[indexPath.row] as? UIImage)!
            Cell.ScreenShotImage.image = preView
            Cell.ScreenShotImage.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3).cgColor
            Cell.ScreenShotImage.layer.borderWidth = 1/UIScreen.main.scale
            return Cell
        }else{
            let DummyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DummyCell", for: indexPath) as! DummyCollectionCell
            return DummyCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == ScreenShotCollectionView {
            let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PreViewCollectionCell
            Cell.ScreenShotImage.image = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ScreenShotCollectionView {
            let newHeight = self.view.frame.height -  64 - 32 - 32
            var newWidth = self.view.frame.width
            
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                let ratio: CGFloat = newHeight / 440 // newHeight, originalWidth
                newWidth = 248 * ratio
            }
            
            return CGSize(width: newWidth, height: newHeight)
        }else{
            return collectionView.frame.size
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        ScreenShotCollectionView.isHidden = true
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        CheckInset()
        ScreenShotCollectionView.reloadData()
        ScreenShotCollectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        ScreenShotCollectionView.isHidden = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == DummyCollectionView {
            page = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
            PageControl.currentPage = page
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == DummyCollectionView {
//            let f  = 0.0004468085 * (self.view.frame.width - 320) + 0.83
            let f  = (0.042/94.0) * (self.view.frame.width - 320) + 0.83
            let horizontalScrollPosition = scrollView.contentOffset.x * f
            self.ScreenShotCollectionView.delegate = nil
            self.ScreenShotCollectionView.contentOffset = CGPoint(x: horizontalScrollPosition, y: 0)
            self.ScreenShotCollectionView.delegate = self
        }
    }
    
    func CheckInset() {
        let collectionViewLayout = ScreenShotCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            collectionViewLayout?.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            collectionViewLayout?.minimumLineSpacing = 0
            
        }else{
            collectionViewLayout?.sectionInset = UIEdgeInsetsMake(0, 36, 0, 36)
            collectionViewLayout?.minimumLineSpacing = 18
        }
        collectionViewLayout?.invalidateLayout()
    }
    
    @IBAction func Dimess(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


class PreViewCollectionCell: UICollectionViewCell {
    @IBOutlet var ScreenShotImage: UIImageView!
}

class DummyCollectionCell: UICollectionViewCell {
    @IBOutlet var DummyLabel: UILabel!
}


