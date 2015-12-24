//
//  SHGithubCacheProcessor.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/23/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation

struct SHGithubCacheProcessor {
    
    static func processReposForCache(repos: [Repository]) -> NSData {
        var archivedRepos: [NSData] = []
        for repo in repos {
            archivedRepos.append(repo.serialized)
        }
        return NSKeyedArchiver.archivedDataWithRootObject(archivedRepos)
    }
    
    static func processReposFromCache(data: NSData) throws -> [Repository] {
        guard let archivedRepos = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [NSData] else {
            
            return []
        }
        
        var repos: [Repository] = []
        for archivedRepo in archivedRepos {
            do {
                let repo = try Repository(serialized: archivedRepo)
                repos.append(repo)
            } catch {
                NSLog("Failed to deserialize one repo")
            }
        }
        
        return repos
    }
}