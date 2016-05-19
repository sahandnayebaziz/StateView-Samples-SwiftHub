//
//  SHGithub.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/22/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SHGitHub: NSObject {
    
    static let go = SHGitHub()
    
    private let endpointRepos = "https://api.github.com/search/repositories"
    private let parameters: [String: String] = ["sort":"stars", "order":"desc"]
    
    private var cache = NSCache()
    
    func getRepositories(cachedOnly: Bool, atPage: Int?, filter: SHGithubCreatedFilter?, receiver: SHGithubDataReceiver?) -> [Repository] {
        
        if let cached = cache.objectForKey(self.createQueryStringForFilter(filter)) as? NSData {
            do {
                let repos = try SHGithubCacheProcessor.processReposFromCache(cached)
                receiver?.receiveNewRepos(repos)
                return repos
            } catch {
                return []
            }
        } else {
            getRepositoriesFromGithub(0, filter: filter, receiver: receiver)
            return []
        }
    }
    
    func getRepositories(cachedOnly: Bool, atPage: Int?, filter: SHGithubCreatedFilter?, completion: ([Repository] -> Void)) -> [Repository] {
        
        if let cached = cache.objectForKey(self.createQueryStringForFilter(filter)) as? NSData {
            do {
                let repos = try SHGithubCacheProcessor.processReposFromCache(cached)
                completion(repos)
                return repos
            } catch {
                return []
            }
        } else {
            getRepositoriesFromGithub(0, filter: filter, completion: completion)
            return []
        }
    }
    
    private func getRepositoriesFromGithub(atPage: Int, filter: SHGithubCreatedFilter?, completion: ([Repository] -> Void)) {
        var urlParams = parameters
        urlParams["q"] = createQueryStringForFilter(filter)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, endpointRepos, parameters: urlParams)
            .validate()
            .responseJSON {
                response in
                guard let data = response.result.value else {
                    if let error = response.result.error {
                        print(error)
                    }
                    return
                }
                
                guard let reposData = JSON(data)["items"].array else {
                    NSLog("malformed JSON response")
                    return
                }
                
                var repos: [Repository] = []
                for repoData in reposData {
                    repos.append(self.createRepoFromJSON(repoData))
                }
                
                self.cache.setObject(SHGithubCacheProcessor.processReposForCache(repos), forKey: self.createQueryStringForFilter(filter))
                completion(repos)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    private func getRepositoriesFromGithub(atPage: Int, filter: SHGithubCreatedFilter?, receiver: SHGithubDataReceiver?) {
        var urlParams = parameters
        urlParams["q"] = createQueryStringForFilter(filter)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, endpointRepos, parameters: urlParams)
            .validate()
            .responseJSON {
                response in
                guard let data = response.result.value else {
                    if let error = response.result.error {
                        print(error)
                    }
                    return
                }
                
                guard let reposData = JSON(data)["items"].array else {
                    NSLog("malformed JSON response")
                    return
                }
                
                var repos: [Repository] = []
                for repoData in reposData {
                    repos.append(self.createRepoFromJSON(repoData))
                }
                
                self.cache.setObject(SHGithubCacheProcessor.processReposForCache(repos), forKey: self.createQueryStringForFilter(filter))
                receiver?.receiveNewRepos(repos)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    private func createRepoFromJSON(json: JSON) -> Repository {
        let name = json["name"].stringValue
        let stars = json["stargazers_count"].intValue
        let owner = json["owner"]["login"].stringValue
        let description = json["description"].stringValue
        let url = json["html_url"].stringValue
        let id = json["id"].intValue
        
        return Repository(name: name, owner: owner, stars: stars, description: description, url: url, id: id)
    }
    
    private func createQueryStringForFilter(filter: SHGithubCreatedFilter?) -> String {
        var queryString = "language:swift"
        if let filter = filter {
            queryString = "\(queryString) \(filter.qualifierString)"
        }
        return queryString
    }
}