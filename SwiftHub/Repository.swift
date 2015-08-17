//
//  Repository.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation

struct Repository {
    var name: String
    var owner: String
    var stars: Int
    
    init(name: String, owner: String, stars: Int) {
        self.name = name
        self.owner = owner
        self.stars = stars
    }
}