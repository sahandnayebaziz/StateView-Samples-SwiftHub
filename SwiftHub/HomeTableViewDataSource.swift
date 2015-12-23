//
//  HomeTableViewDataSource.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class HomeTableViewDataSource: NSObject, UITableViewDataSource, SHGithubDataReceiver {
    
    var tableView: UITableView? = nil
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SHGithub.go.getRepositories(false, atPage: 0, receiver: self).count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell", forIndexPath: indexPath) as! HomeTableViewCell
        let repo = SHGithub.go.getRepositories(true, atPage: nil, receiver: nil)[indexPath.row]

        cell.configureCell(repo)
        
        return cell
    }
    
    func receiveNewRepos(repos: [Repository]) {
        guard let tableView = tableView else {
            fatalError("Table view can not be used from HomeTableViewDataSource before it has been assigned.")
        }
        
        tableView.reloadData()
    }

}
