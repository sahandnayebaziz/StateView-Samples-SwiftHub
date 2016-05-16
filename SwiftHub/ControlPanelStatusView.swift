//
//  ControlPanelStatusView.swift
//  SwiftHub
//
//  Created by Nayebaziz, Sahand on 5/15/16.
//  Copyright © 2016 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import StateView

class ControlPanelStatusView: StateView {
    
    override func render() {
        
        guard let key = prop(withValueForKey: ControlPanelViewKey.StatusKey) as? String, let value = prop(withValueForKey: ControlPanelViewKey.StatusValue) as? String else {
            fatalError("A ControlPanelStatusView must be initialized with a StatusKey and StatusValue")
        }
        
        let label = UILabel()
        let text = NSMutableAttributedString(string: "\(key): \(value)")
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, key.characters.count + 1))
        
        label.font = UIFont.systemFontOfSize(15)
        label.attributedText = text
        place(label, key: "StatusLabel") { make in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))
    }
    
    func viewTapped() {
        if let action = prop(withFunctionForKey: ControlPanelViewKey.StatusTappedSelector) {
            action([:])
        }
    }
}