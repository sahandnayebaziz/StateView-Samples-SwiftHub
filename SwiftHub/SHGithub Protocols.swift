//
//  SHGithub Protocols.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/22/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation

protocol SHGithubDataReceiver {
    func receiveNewRepos(_ repos: [Repository])
}
