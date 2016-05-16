//
//  HomeTableViewDataSource.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class HomeTableViewDataSource: NSObject, UITableViewDataSource, SHGithubDataReceiver, FilteredDisplayDelegate {
    
    var tableView: UITableView? = nil
    
    var receivedRepos: [Repository] = []
    var receivedFilters: [SHGithubCreatedFilter] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedRepos.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell", forIndexPath: indexPath) as! HomeTableViewCell
        cell.configureCell(receivedRepos[indexPath.row])
        return cell
    }
    
    func receiveNewRepos(repos: [Repository]) {
        guard let tableView = tableView else {
            fatalError("Table view can not be used from HomeTableViewDataSource before it has been assigned.")
        }
        
        self.receivedRepos = repos
        tableView.reloadData()
    }
    
    func didReceiveFilters(filters: [SHGithubCreatedFilter]) {
        self.receivedFilters = filters
        SHGitHub.go.getRepositories(false, atPage: 0, filters: filters, receiver: self)
    }

}
