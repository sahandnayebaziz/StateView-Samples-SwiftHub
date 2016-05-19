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
        guard nameLabel == nil && descriptionLabel == nil else {
            return
        }
        
        let newNameLabel = UILabel()
        addSubview(newNameLabel)
        newNameLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        newNameLabel.snp_makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(12)
            make.right.equalTo(self).offset(-14)
            make.height.equalTo(20)
        }
        self.nameLabel = newNameLabel
        
        let newDescriptionLabel = UILabel()
        addSubview(newDescriptionLabel)
        newDescriptionLabel.font = UIFont.systemFontOfSize(11, weight: UIFontWeightRegular)
        newDescriptionLabel.textColor = SHColors.graySubtitle
        newDescriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(newNameLabel.snp_bottom).offset(2)
            make.left.equalTo(newNameLabel)
            make.right.equalTo(newNameLabel)
            make.height.equalTo(14)
        }
        self.descriptionLabel = newDescriptionLabel
        
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
