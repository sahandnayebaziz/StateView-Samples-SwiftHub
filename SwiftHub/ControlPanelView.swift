//
//  ControlPanelView.swift
//  SwiftHub
//
//  Created by Nayebaziz, Sahand on 5/15/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import StateView

enum ControlPanelViewKey: StateKey {
    case
    statusKey,
    statusValue,
    statusTappedSelector
}

class ControlPanelView: StateView, FilteredDisplayDelegate {
    
    override func render() {
        
        backgroundColor = UIColor.white
        clipsToBounds = true
        layer.cornerRadius = 4.0
        
        let createdAtStatus = place(ControlPanelStatusView.self, key: "createdStatus") { make in
            make.height.equalTo(self)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-28)
            make.width.equalTo(self).dividedBy(2).offset(-56)
        }
        
        createdAtStatus.prop(forKey: ControlPanelViewKey.statusKey, is: "Filter")
        if let filter = prop(withValueForKey: HomeViewKey.filter) as? SHGithubCreatedFilter {
            createdAtStatus.prop(forKey: ControlPanelViewKey.statusValue, is: filter.prettyString)
        } else {
            createdAtStatus.prop(forKey: ControlPanelViewKey.statusValue, is: "none")
        }
        createdAtStatus.prop(forKey: ControlPanelViewKey.statusTappedSelector) { _ in
            self.parentViewController.present(FilterAlertViewController(delegate: self), animated: true, completion: nil)
        }
    }
    
    func didReceiveFilter(_ filter: SHGithubCreatedFilter?) {
        prop(withFunctionForKey: HomeViewKey.didReceiveFilter)!(["filter": filter])
    }
}
