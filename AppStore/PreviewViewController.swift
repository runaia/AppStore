//
//  PreviewViewController.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 31..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    var viewModel = PreviewViewModel()
    var imageArray = [String]()
    var startPage: Int?
    
    @IBOutlet var previewCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
        viewModel.loadData(data: imageArray)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styleUI()
    }
    
    fileprivate func styleUI() {
        if let layout = previewCollectionView.collectionViewLayout as? HorizontalFlowLayout {
            layout.itemSize.width = (previewCollectionView.bounds.height / layout.itemSize.height) * layout.itemSize.width
            layout.itemSize.height = previewCollectionView.bounds.height
            layout.baseLineX = previewCollectionView.bounds.width * 0.5
            
            let spacing = (previewCollectionView.bounds.width - layout.itemSize.width) * 0.5
            if UIDevice.current.orientation.isLandscape { layout.minimumLineSpacing = spacing }
            else { layout.minimumLineSpacing = spacing * 0.5 }
            
            previewCollectionView.contentInset.left = spacing
            previewCollectionView.contentInset.right = spacing
            previewCollectionView.collectionViewLayout = layout
            previewCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
            
            if let page = startPage {
                viewModel.indexScroll(collectionView: previewCollectionView, index: page, animated: false)
                startPage = nil
            }
        }
    }
    
    fileprivate func fillUI() {
        viewModel.item.bind { [weak self](_) in self?.previewCollectionView.reloadData() }
        viewModel.numberOfPages.bind { [weak self] in self?.pageControl.numberOfPages = $0 }
        viewModel.currentPage.bind { [weak self] in self?.pageControl.currentPage = $0 }
        viewModel.scrollToPoint.bind { [weak self] in self?.previewCollectionView.setContentOffset($0.point, animated: $0.animated) }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.previewCollectionView.collectionViewLayout.invalidateLayout()
            self.previewCollectionView?.reloadData()
            
        }) { (_) in
            self.viewModel.indexScroll(collectionView: self.previewCollectionView, index: self.pageControl.currentPage, animated: true)
        }
    }
    
    
    @IBAction func Dimess(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.item.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PreviewCollectionViewCell
        Cell.configure(withURL: viewModel.item.value[indexPath.row])
        return Cell
    }
}

extension PreviewViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            else { return }
        
        let width = layout.itemSize.width + layout.minimumLineSpacing
        let x = targetContentOffset.pointee.x + collectionView.contentInset.left + (layout.itemSize.width * 0.5)
        viewModel.currentPage.value = Int(x/width)
    }
}
