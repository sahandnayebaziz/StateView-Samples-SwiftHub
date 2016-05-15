//
//  HomeViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

class HomeViewController: UIViewController, UITableViewDelegate, FilteredDisplayDelegate {
    
    var dataSource: HomeTableViewDataSource
    var tableView: UITableView
    
    init() {
        self.dataSource = HomeTableViewDataSource()
        tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
        
        title = "Swift Repositories"
        view.backgroundColor = SHColors.grayBlue
        
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.height.equalTo(self.view)
            make.width.equalTo(self.view).offset(-24)
            make.center.equalTo(self.view)
        }
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        
        tableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.dataSource = self.dataSource
        dataSource.tableView = tableView
        tableView.delegate = self
        
        let button = FloatingButton(title: "Filters")
        view.addSubview(button)
        button.snp_makeConstraints { make in
            make.width.equalTo(117)
            make.height.equalTo(37)
            make.bottom.equalTo(self.view.snp_bottom).offset(-16)
            make.right.equalTo(self.view.snp_right).offset(-28)
        }
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedFilter)))
        
        SHGitHub.go.getRepositories(false, atPage: 0, filters: nil, receiver: dataSource)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = SFSafariViewController(URL: dataSource.receivedRepos[indexPath.row].url)
        presentViewController(viewController, animated: true) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tappedFilter() {
        presentViewController(FilterAlertViewController(delegate: self), animated: true, completion: nil)
    }
    
    func shouldUpdateWithFilters(filters: [SHGithubCreatedFilter]) {
        dataSource.shouldUpdateWithFilters(filters)
    }
}
