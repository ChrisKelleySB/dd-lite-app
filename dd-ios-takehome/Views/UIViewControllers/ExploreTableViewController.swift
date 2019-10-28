//
//  ExploreViewController.swift
//  dd-ios-takehome
//
//  Created by Christopher Kelley on 10/25/19.
//  Copyright © 2019 Christopher Kelley. All rights reserved.
//

import UIKit

class ExploreTableViewController: UITableViewController {
    var exploreResults = ExploreResultArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ExploreTableViewCell", bundle: nil), forCellReuseIdentifier: ExploreTableViewCell.reuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exploreResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ExploreTableViewCell.reuseIdentifier, for: indexPath) as? ExploreTableViewCell

        if cell == nil {
            cell = ExploreTableViewCell(style: .default, reuseIdentifier: ExploreTableViewCell.reuseIdentifier)
        }

        cell!.layoutViewForItem(exploreItem: exploreResults[indexPath.row])

        return cell!
    }


}
