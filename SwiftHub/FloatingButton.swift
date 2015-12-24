//
//  FloatingButton.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/22/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class FloatingButton: UIView {
    
    let label = UILabel()

    init(title: String) {
        super.init(frame: CGRectZero)
        
        backgroundColor = SHColors.grayBlue
        layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.33).CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.17
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 8
        
        label.font = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        label.textColor = SHColors.blue
        label.textAlignment = .Center
        label.text = title
        
        addSubview(label)
        label.snp_makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self.snp_width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
