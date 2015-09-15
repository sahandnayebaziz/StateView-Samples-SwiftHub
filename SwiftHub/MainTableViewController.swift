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
    var pagesDownloaded = 0
    
    
    
    
    
    
    
    override func viewDidLoad() {
        title = "Repos"
        tableView.registerClass(RepoPreviewTableViewCell.self, forCellReuseIdentifier: "repoCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "openFilters")
    }
    
    func openFilters() {
        let vc = MainFiltersTableViewController(style: .Grouped)
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if repos.isEmpty {
           fetchData()
        }
    }
    
    func fetchData() {
        if pagesDownloaded < 5 {
            pagesDownloaded += 1
            GHAPIManager.downloadRepositories(self, atPage: pagesDownloaded)
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let vc = RepositoryDetailViewController()
        vc.detailItem = repo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == repos.count - 1 && repos.count > (20 * pagesDownloaded) {
            print("did start fetch")
            fetchData()
        }
    }

    
    
    
    
    
    
    
    func insertNewRepo(repo: Repository) {
        tableView.beginUpdates()
        repos.append(repo)
        let indexPath = NSIndexPath(forRow: repos.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    

}
