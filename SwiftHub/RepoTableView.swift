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
            tableView.backgroundColor = UIColor.clear
            tableView.separatorStyle = .none
            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            
            addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.size.equalTo(self)
                make.center.equalTo(self)
            }
            self.tableView = tableView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repos = prop(withValueForKey: HomeViewKey.repositories) as? [Repository] else { fatalError() }
        
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repos = prop(withValueForKey: HomeViewKey.repositories) as? [Repository] else { fatalError() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.configureCell(repos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repos = prop(withValueForKey: HomeViewKey.repositories) as? [Repository] else { fatalError() }
        
        let viewController = SFSafariViewController(url: repos[indexPath.row].url)
        parentViewController.present(viewController, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
