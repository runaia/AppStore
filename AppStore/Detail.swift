//
//  Detail.swift
//  AppStore
//
//  Created by seojiwon on 2017. 8. 28..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class Detail: UITableViewController {
    var subTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = subTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
