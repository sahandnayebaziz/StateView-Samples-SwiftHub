//
//  HomeViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import StateView

class HomeStateViewController: StateViewController {
    
    override func viewDidLoad() {
        title = "SwiftHub"
        view.backgroundColor = SHColors.grayBlue
        rootView = HomeView(parentViewController: self)
    }
}

