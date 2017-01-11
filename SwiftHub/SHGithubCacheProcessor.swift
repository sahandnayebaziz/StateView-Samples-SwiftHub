//
//  SHGithubCacheProcessor.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/23/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation

struct SHGithubCacheProcessor {
    
    static func processReposForCache(_ repos: [Repository]) -> NSData {
        var archivedRepos: [NSData] = []
        for repo in repos {
            archivedRepos.append(repo.serialized)
        }
        return NSKeyedArchiver.archivedData(withRootObject: archivedRepos) as NSData
    }
    
    static func processReposFromCache(_ data: NSData) throws -> [Repository] {
        guard let archivedRepos = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [NSData] else {
            
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
