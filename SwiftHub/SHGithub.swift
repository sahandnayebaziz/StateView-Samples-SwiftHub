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

class SHGithub: NSObject {
    
    static let go = SHGithub()
    
    private let endpointRepos = "https://api.github.com/search/repositories"
    private let parameters: [String: String] = ["sort":"stars", "order":"desc"]
    
    private var cache = NSCache()
    
    func getRepositories(cachedOnly: Bool, atPage: Int?, filters: [SHGithubFilterType]?, receiver: SHGithubDataReceiver?) -> [Repository] {
        
        if let cached = cache.objectForKey(self.createQueryStringForFilters(filters)) as? NSData {
            do {
                let repos = try SHGithubCacheProcessor.processReposFromCache(cached)
                receiver?.receiveNewRepos(repos)
                return repos
            } catch {
                return []
            }
        } else {
            getRepositoriesFromGithub(0, filters: filters, receiver: receiver)
            return []
        }
    }
    
    private func getRepositoriesFromGithub(atPage: Int, filters: [SHGithubFilterType]?, receiver: SHGithubDataReceiver?) {
        var urlParams = parameters
        urlParams["q"] = createQueryStringForFilters(filters)
        
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
                
                self.cache.setObject(SHGithubCacheProcessor.processReposForCache(repos), forKey: self.createQueryStringForFilters(filters))
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
    
    private func createQueryStringForFilters(filters: [SHGithubFilterType]?) -> String {
        var queryString = "language:swift"
        if let filters = filters {
            for filter in filters {
                queryString = "\(queryString) \(filter.qualifierString)"
            }
        }
        return queryString
    }
}