//
//  DetailViewController.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 26..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

protocol DetailViewCellProtocol {
    func configure(withDataSource dataSource: DetailViewModelItem)
}

class DetailViewController: UIViewController {

    @IBOutlet var starRatingWidth: NSLayoutConstraint!
    @IBOutlet var starRatingProgressView: UIView!
    @IBOutlet var appInfoView: UIView!
    @IBOutlet var appIconImage: AsyncImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var artistButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var userRatingLabel: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var contentsTableView: UITableView!
    
    var appData: ListViewModelItem?
    var viewModel = DetailViewModel()
    var segmentCell: SegmentTableViewCell?
    var estimated: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
        viewModel.loadData(by: appData)
    }
    
    fileprivate func styleUI() {
        contentsTableView.tableFooterView = UIView(frame: .zero)
        segmentCell = contentsTableView.dequeueReusableCell(withIdentifier: "Segment") as? SegmentTableViewCell
        segmentCell?.lineHeight.constant = 1/UIScreen.main.scale
        contentsTableView.sectionHeaderHeight = 64
        contentsTableView.estimatedRowHeight = 10000
        contentsTableView.rowHeight = UITableViewAutomaticDimension
        
        appIconImage.layer.cornerRadius = appIconImage.frame.width/4
        appIconImage.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.3).cgColor
        appIconImage.layer.borderWidth = 1/UIScreen.main.scale
        
        trackLabel.layer.borderColor = UIColor.init(r: 99, g: 99, b: 99, a: 1.0).cgColor
        trackLabel.layer.borderWidth = 1
        
        downloadButton.layer.cornerRadius = 3;
        downloadButton.layer.borderColor = UIColor.init(r: 0, g: 122, b: 255, a: 1.0).cgColor
        downloadButton.layer.borderWidth = 1.0
    }
    
    fileprivate func fillUI() {
        viewModel.title.bind { [weak self] in self?.titleLabel.text = $0 }
        viewModel.artist.bind { [weak self] in self?.artistButton.setTitle($0, for:.normal) }
        viewModel.appIconUrl.bind { [weak self] in self?.appIconImage.loadImage(urlString: $0) }
        viewModel.advisoryRating.bind { [weak self] in self?.trackLabel.text = $0 }
        viewModel.ratingCount.bind { [weak self] in self?.userRatingLabel.text = $0 }
        viewModel.ratingPercent.bind { [weak self] in self?.starRatingWidth = self?.starRatingWidth.changeMultiPlier(change: CGFloat($0)) }
        viewModel.item.bind { [weak self](_) in
            self?.contentsTableView.reloadData()
            self?.contentsTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        viewModel.isLoading.bind { [weak self] in $0 ? self?.indicator.startAnimating(): self?.indicator.stopAnimating() }
    }
    
    @IBAction func SelectScreenshotEvent(_ sender: UIButton) {
        performSegue(withIdentifier: "preview", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "preview") {
            guard
                let previewItems = viewModel.previewItems,
                let selectRow = (sender as? UIView)?.tag,
                let destination = segue.destination as? PreviewViewController else { return }
            
            destination.imageArray = previewItems
            destination.startPage = selectRow
        }
    }
    
}


extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard estimated else {
            estimated = true
            return
        }
        
        if scrollView == contentsTableView {
            let offSetY = scrollView.contentOffset.y
            let transY = appInfoView.frame.height - 64

            if offSetY <= transY { segmentCell?.bg.backgroundColor = UIColor.white }
            else { segmentCell?.bg.backgroundColor = UIColor.clear }
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentCell?.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.item.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let item = viewModel.item.value[indexPath.row]
        
        switch item.type {
        case .preView: cell = tableView.dequeueReusableCell(withIdentifier: "PreView", for: indexPath) as! ScreenshotTableViewCell
        case .desc: cell = tableView.dequeueReusableCell(withIdentifier: "Desc", for: indexPath) as! DescTableViewCell
        case .info: cell = tableView.dequeueReusableCell(withIdentifier: "Info", for: indexPath) as! InfoTableViewCell
        case .copyright: cell = tableView.dequeueReusableCell(withIdentifier: "Copyright", for: indexPath) as! CopyrightTableViewCell
        default:
            cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = item.title
            return cell
        }
        
        let detailCell = cell as? DetailViewCellProtocol
        detailCell?.configure(withDataSource: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item.value[indexPath.row]
        
        switch item.type {
        case .desc:
            guard let descData = item as? Desc else { return }
            if !descData.expand {
                descData.expand = true
                estimated = false
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        case .link:
            guard
                let linkData = item as? Link,
                let url = URL(string: linkData.url) else { return }

            UIApplication.shared.openURL(url) //Safari 이동
            
        default :
            return
        }
    }
}






