//
//  RepoTableView.swift
//  SwiftHub
//
//  Created by Nayebaziz, Sahand on 5/19/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import StateView
import SafariServices

class RepoTableView: StateView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView? = nil
    
    override func viewDidUpdate() {
        tableView?.reloadData()
    }
    
    override func render() {
        if tableView == nil {
            let tableView = UITableView()
            tableView.backgroundColor = UIColor.clearColor()
            tableView.separatorStyle = .None
            tableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            
            addSubview(tableView)
            tableView.snp_makeConstraints { make in
                make.size.equalTo(self)
                make.center.equalTo(self)
            }
            self.tableView = tableView
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repos = prop(withValueForKey: HomeViewKey.Repositories) as? [Repository] else { fatalError() }
        
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let repos = prop(withValueForKey: HomeViewKey.Repositories) as? [Repository] else { fatalError() }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableViewCell", forIndexPath: indexPath) as! HomeTableViewCell
        cell.configureCell(repos[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let repos = prop(withValueForKey: HomeViewKey.Repositories) as? [Repository] else { fatalError() }
        
        let viewController = SFSafariViewController(URL: repos[indexPath.row].url)
        parentViewController.presentViewController(viewController, animated: true) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
}
