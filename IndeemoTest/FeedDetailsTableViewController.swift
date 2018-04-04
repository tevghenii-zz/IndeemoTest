//
//  FeedDetailsTableViewController.swift
//  IndeemoTest
//
//  Created by Evghenii Todorov on 4/4/18.
//  Copyright © 2018 Todorov Evghenii. All rights reserved.
//

import UIKit

class FeedDetailsTableViewController: UITableViewController {
    
    var feedItem: FeedItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Details", value: "Details", comment: "")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.tableFooterView = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("Id", value: "Id", comment: "")
            cell.detailTextLabel?.text = "\(feedItem.id)"
            cell.detailTextLabel?.numberOfLines = 1
        case 1:
            cell.textLabel?.text = NSLocalizedString("User Id", value: "User Id", comment: "")
            cell.detailTextLabel?.text = "\(feedItem.userId)"
            cell.detailTextLabel?.numberOfLines = 1
        case 2:
            cell.textLabel?.text = feedItem.title
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = ""
        case 3:
            cell.textLabel?.text = feedItem.body
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = ""
        default:
            break
        }

        return cell
    }
}
