//
//  SavedReposTableViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/11/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class SavedReposTableViewController: UITableViewController {
    
    var repos: [Repository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(RepoPreviewTableViewCell.self, forCellReuseIdentifier: "savedRepo")
        title = "Saved"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .Plain, target: navigationController, action: "dismiss")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        repos = SaveManager.allSavedRepositories()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return repos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("savedRepo", forIndexPath: indexPath) as! RepoPreviewTableViewCell
        cell.setCell(repos[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let vc = RepoSafariViewController(URL: repo.url)
        vc.repo = repo
        navigationController?.pushViewController(vc, animated: true)
    }

}
