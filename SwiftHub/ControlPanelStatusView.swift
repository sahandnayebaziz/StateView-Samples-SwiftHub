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
        
        guard let key = prop(withValueForKey: ControlPanelViewKey.statusKey) as? String, let value = prop(withValueForKey: ControlPanelViewKey.statusValue) as? String else {
            fatalError("A ControlPanelStatusView must be initialized with a StatusKey and StatusValue")
        }
        
        let label = UILabel()
        let text = NSMutableAttributedString(string: "\(key): \(value)")
        text.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSMakeRange(0, key.characters.count + 1))
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.attributedText = text
        let _ = place(label, key: "StatusLabel") { make in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))
    }
    
    func viewTapped() {
        if let action = prop(withFunctionForKey: ControlPanelViewKey.statusTappedSelector) {
            action([:])
        }
    }
}
