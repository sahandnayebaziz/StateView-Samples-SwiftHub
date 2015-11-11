//
//  SaveManager.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/11/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct SaveManager {
    
    static private var defaultsKeyForSavedRepos = "saved_repos"
    
    static func repoIsSaved(repository: Repository) -> Bool {
        let repos = getSavedData()
        return repos.contains(repository)
    }
    
    static func saveRepo(newRepository: Repository, completion: (()->Void)?) {
        var repos = getSavedData()
        repos.insert(newRepository)
        updateSavedData(repos)
        print("saved \(newRepository.name)")
        
        guard let completion = completion else {
            return
        }
        dispatch_to_main_queue {
            completion()
        }
    }
    
    static func deleteRepo(oldRepository: Repository, completion: (()->Void)?) {
        var repos = getSavedData()
        repos.remove(oldRepository)
        updateSavedData(repos)
        print("removed \(oldRepository.name)")
        
        guard let completion = completion else {
            return
        }
        dispatch_to_main_queue {
            completion()
        }
    }
    
    static func allSavedRepositories() -> [Repository] {
        let repositories = getSavedData()
        return Array(repositories)
    }
    
    private static func updateSavedData(newData: Set<Repository>) {
        var archivedRepos: [NSData] = []
        
        for repo in newData {
            archivedRepos.append(repo.serialized)
        }
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(archivedRepos)
        Defaults[defaultsKeyForSavedRepos] = data
        Defaults.synchronize()
        
        // completion
    }
    
    private static func getSavedData() -> Set<Repository> {
        guard let data = Defaults[defaultsKeyForSavedRepos].data else {
            return []
        }
        
        guard let archivedRepos = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [NSData] else {
            return []
        }
        
        var savedRepos: Set<Repository> = []
        
        for data in archivedRepos {
            do {
                let repo = try Repository(serialized: data)
                savedRepos.insert(repo)
            } catch {
                NSLog("failed to deserialize repository")
            }
        }
        
        return savedRepos
    }
    
}
