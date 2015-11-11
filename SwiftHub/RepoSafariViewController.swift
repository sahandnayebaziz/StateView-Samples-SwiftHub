//
//  RepoSafariViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/11/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SafariServices

class RepoSafariViewController: SFSafariViewController {
    
    var repo: Repository!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = repo.name
        navigationItem.rightBarButtonItem = determineNavigationItem()
    }

    
    func determineNavigationItem() -> UIBarButtonItem {
        // if is favorited
        if SaveManager.repoIsSaved(repo) {
            return UIBarButtonItem(image: UIImage(named: "Saved"), style: .Plain, target: self, action: "unsave")
        } else {
            return UIBarButtonItem(image: UIImage(named: "Save"), style: .Plain, target: self, action: "save")
        }
    }
    
    func save() {
        SaveManager.saveRepo(repo) {
            self.navigationItem.rightBarButtonItem = self.determineNavigationItem()
        }
    }
    
    func unsave() {
        SaveManager.deleteRepo(repo) {
            self.navigationItem.rightBarButtonItem = self.determineNavigationItem()
        }
    }

}
