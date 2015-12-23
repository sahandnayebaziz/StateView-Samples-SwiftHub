//
//  HomeTableViewCell.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/22/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel? = nil
    var descriptionLabel: UILabel? = nil
    var starsLabel: UILabel? = nil
    var separatorView: UIView? = nil
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(repo: Repository) {
        backgroundColor = UIColor.whiteColor()
        createSubviewsIfNotCreated()
        
        guard let nameLabel = self.nameLabel else {
            fatalError("Home table view cell subviews were not created before being used.")
        }
        
        guard let descriptionLabel = self.descriptionLabel else {
            fatalError("Home table view cell subviews were not created before being used.")
        }
        
        nameLabel.text = repo.name
        descriptionLabel.text = repo.description
    }
    
    private func createSubviewsIfNotCreated() {
        if nameLabel == nil {
            let newNameLabel = UILabel()
            addSubview(newNameLabel)
            newNameLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            newNameLabel.snp_makeConstraints { make in
                make.left.equalTo(10)
                make.top.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(20)
            }
            self.nameLabel = newNameLabel
        }
        
        if descriptionLabel == nil {
            let newDescriptionLabel = UILabel()
            addSubview(newDescriptionLabel)
            newDescriptionLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
            newDescriptionLabel.textColor = SHColors.grayLight
            newDescriptionLabel.snp_makeConstraints { make in
                make.bottom.equalTo(self).offset(-8)
                make.left.equalTo(10)
                make.right.equalTo(self).offset(-10)
                make.height.equalTo(14)
            }
            self.descriptionLabel = newDescriptionLabel
        }
        
        if separatorView == nil {
            let newSeparatorView = UIView()
            newSeparatorView.backgroundColor = SHColors.grayLightest
            addSubview(newSeparatorView)
            newSeparatorView.snp_makeConstraints { make in
                make.height.equalTo(1)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
            }
            self.separatorView = newSeparatorView
        }
        
    }

}
