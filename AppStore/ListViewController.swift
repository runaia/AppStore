//
//  ListViewController.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 25..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController  {
    
    @IBOutlet var listTableView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var reloadView: UIView!
    
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
        viewModel.loadData()
    }
    fileprivate func styleUI() {
        listTableView.tableFooterView = UIView(frame: .zero)
    }
    
    fileprivate func fillUI() {
        viewModel.title.bind { [weak self] in self?.title = $0 }
        viewModel.indicatorAnimating.bind { [weak self] in
            if $0 { self?.indicator.startAnimating() }
            else { self?.indicator.stopAnimating() }
        }
        viewModel.reload.bind { [weak self] in self?.reloadView.isHidden = !$0 }
        viewModel.item.bind { [weak self](_) in self?.listTableView.reloadData() }
    }
    
    @IBAction func reload(_ sender: Any) {
        viewModel.loadData()
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.item.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppList", for: indexPath ) as! AppListTableViewCell
        let item = viewModel.item.value[indexPath.row]
        
        let rank: Int = indexPath.row + 1
        cell.configure(withDataSource: item, rank: rank)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "selectApp":
            guard
                let selectRow = listTableView.indexPathForSelectedRow?.row,
                let destination = segue.destination as? DetailViewController else { return }
            
            destination.appData = viewModel.item.value[selectRow]
            
        default:
            return
        }
    }
    
}
