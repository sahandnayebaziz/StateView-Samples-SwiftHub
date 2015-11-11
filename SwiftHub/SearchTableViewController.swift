//
//  SearchTableViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/10/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import PromiseKit
import SafariServices
import BRYXBanner

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var results: [Repository] = []
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search Swift repos by name"
        searchController.searchBar.autocapitalizationType = .None
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        tableView.registerClass(RepoPreviewTableViewCell.self, forCellReuseIdentifier: "searchCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .Plain, target: navigationController, action: "dismiss")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchController.active = true
        searchController.searchBar.hidden = false
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
        return results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! RepoPreviewTableViewCell
        cell.setCell(results[indexPath.row])
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        if searchText.characters.count >= 5 {
            let filter = RepositoriesFilter(name: "Search text", type: .Name, qualifier: searchText)
            GHAPIManager.getRepositories(withFilters: [filter]).then { results -> Void in
                self.results = results
                self.tableView.reloadData()
                }.recover { e -> Void in
                    BannerManager.sharedInstance.notifyAPILimit()
            }
        } else {
            dispatch_to_main_queue {
                self.results = []
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("got cancel")
        navigationController?.dismiss()
    }
    
    
    // TODO: don't duplicate this three times like it is now
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = results[indexPath.row]
        let vc = RepoSafariViewController(URL: repo.url)
        vc.repo = repo
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


