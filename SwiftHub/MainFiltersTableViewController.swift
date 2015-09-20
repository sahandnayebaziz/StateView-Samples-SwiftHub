//
//  MainFiltersTableViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/18/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit



class MainFiltersTableViewController: UITableViewController {
    
    var delegate: RepoViewDelegate!
    var filterGroups:[[RepositoriesFilter]] = []
    var selectedFilters: [RepositoriesFilter] = []

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Filters"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "filterCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "dismiss")
        self.clearsSelectionOnViewWillAppear = false
    }
    
    func selectRowForFilters(filters: [RepositoriesFilter]) {
        if filterGroups.isEmpty {
            filterGroups.append(GHAPIManager.createDateQualifiers())
        }
        
        selectedFilters = filters
        for filter in filters {
            if filter.type == "date" {
                if let indexOfFilter = filterGroups[0].indexOf(filter) {
                    tableView.selectRowAtIndexPath(NSIndexPath(forRow: indexOfFilter, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
                }
            }
        }
        
    }
    
    func dismiss() {
        delegate.refreshReposWithNewFilters(selectedFilters)
        dismissViewControllerAnimated(true, completion: nil)
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterGroups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGroups[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) 
        let filter = filterGroups[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = filter.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        let filter = filterGroups[indexPath.section][indexPath.row]
        
        selectedFilters = selectedFilters.filter { $0.type != filter.type }
        selectedFilters.append(filter)
        
        cell.accessoryType = .Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        cell.accessoryType = .None
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "created"
        }
        return nil
    }
    

}
