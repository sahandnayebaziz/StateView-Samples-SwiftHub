//
//  HomeViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UITableViewDelegate {
    
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
        tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
}
