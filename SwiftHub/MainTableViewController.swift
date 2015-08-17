//
//  MainTableViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainTableViewController: UITableViewController {

    var repos: [Repository] = []
    
    
    
    
    
    
    
    override func viewDidLoad() {
        title = "Repos"
        tableView.registerClass(RepoPreviewTableViewCell.self, forCellReuseIdentifier: "repoCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        GHAPIManager.downloadRepositories(self)
    }
    
    
    
    
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath) as! RepoPreviewTableViewCell

        let repo = repos[indexPath.row]
        return cell.setCell(repo)
    }

    
    
    
    
    
    
    
    func insertNewRepo(repo: Repository) {
        tableView.beginUpdates()
        repos.append(repo)
        let indexPath = NSIndexPath(forRow: repos.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    

}
