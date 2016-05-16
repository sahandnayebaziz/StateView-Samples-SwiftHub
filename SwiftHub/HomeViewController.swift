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
            make.height.equalTo(self.view).offset(-72)
            make.width.equalTo(self.view).offset(-24)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        
        tableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.dataSource = self.dataSource
        dataSource.tableView = tableView
        tableView.delegate = self
        
        let controlPanel = ControlPanelView(parentViewController: self)
        view.addSubview(controlPanel)
        controlPanel.snp_makeConstraints { make in
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(self.view).offset(-24)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view).offset(-13)
        }
        controlPanel.renderDeep()
        
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
    
    func didReceiveFilters(filters: [SHGithubCreatedFilter]) {
        dataSource.didReceiveFilters(filters)
    }
}
