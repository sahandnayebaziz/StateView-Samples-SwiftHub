//
//  SwiftHubSafariViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/11/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SafariServices

class SwiftHubSafariViewController: SFSafariViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Saved"), style: .Plain, target: self, action: "bookmark")
    }
}
