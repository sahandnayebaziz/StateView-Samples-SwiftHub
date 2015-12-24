//
//  Home Protocols.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/21/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

protocol RepoViewDelegate {
    func refreshReposWithNewFilters(filters: [RepositoriesFilter]?)
}

protocol FilteredDisplayDelegate {
    func shouldUpdateWithFilters(filters: [SHGithubFilterType])
}