//
//  BannerManager.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/10/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import BRYXBanner


// TODO: don't allow multiple identical banners, but allow different banners to stack?
class BannerManager {
    
    static let sharedInstance = BannerManager()
    
    fileprivate var isShowingBanner = false
    fileprivate var currentBanner: Banner? = nil
    
    fileprivate var colorPrimary = UIColor(red: 255/255.0, green: 75/255.0, blue: 14/255.0, alpha: 1)
    
    func notifyAPILimit() {
        displayBannerWith("Reached API Limit", subtitle: "Please wait one minute and try again!", color: colorPrimary)
    }
    
    fileprivate func displayBannerWith(_ title: String, subtitle: String, color: UIColor) {
        let banner = Banner(title: title, subtitle: subtitle, image: nil, backgroundColor: color, didTapBlock: nil)
        banner.dismissesOnTap = true
        banner.dismissesOnSwipe = true
        if let current = currentBanner {
            current.didDismissBlock = {
                banner.show()
                self.currentBanner = banner
            }
            current.dismiss()
        } else {
            banner.show()
            currentBanner = banner
        }
    }
    
}
