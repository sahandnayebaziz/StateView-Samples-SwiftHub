//
//  UINavigationController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/10/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

extension UINavigationController {
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}