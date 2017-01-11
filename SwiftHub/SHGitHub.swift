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
    
    fileprivate let endpointRepos = "https://api.github.com/search/repositories"
    fileprivate let parameters: [String: String] = ["sort":"stars", "order":"desc"]
    
    fileprivate var cache = NSCache<NSString, NSData>()
    
    func getRepositories(_ cachedOnly: Bool, atPage: Int?, filter: SHGithubCreatedFilter?, receiver: SHGithubDataReceiver?) -> [Repository] {
        
        if let cached = cache.object(forKey: self.createQueryStringForFilter(filter) as NSString) {
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
    
    func getRepositories(_ cachedOnly: Bool, atPage: Int?, filter: SHGithubCreatedFilter?, completion: @escaping (([Repository]) -> Void)) -> [Repository] {
        
        if let cached = cache.object(forKey: self.createQueryStringForFilter(filter) as NSString) as? Data {
            do {
                let repos = try SHGithubCacheProcessor.processReposFromCache(cached as NSData)
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
    
    fileprivate func getRepositoriesFromGithub(_ atPage: Int, filter: SHGithubCreatedFilter?, completion: @escaping (([Repository]) -> Void)) {
        var urlParams = parameters
        urlParams["q"] = createQueryStringForFilter(filter)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        request(endpointRepos, method: .get, parameters: urlParams, encoding: URLEncoding.default, headers: nil)
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
                
                self.cache.setObject(SHGithubCacheProcessor.processReposForCache(repos), forKey: self.createQueryStringForFilter(filter) as NSString)
                completion(repos)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    fileprivate func getRepositoriesFromGithub(_ atPage: Int, filter: SHGithubCreatedFilter?, receiver: SHGithubDataReceiver?) {
        var urlParams = parameters
        urlParams["q"] = createQueryStringForFilter(filter)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        request(endpointRepos, method: .get, parameters: urlParams, encoding: URLEncoding.default, headers: nil)
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
                
                self.cache.setObject(SHGithubCacheProcessor.processReposForCache(repos), forKey: self.createQueryStringForFilter(filter) as NSString)
                receiver?.receiveNewRepos(repos)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    fileprivate func createRepoFromJSON(_ json: JSON) -> Repository {
        let name = json["name"].stringValue
        let stars = json["stargazers_count"].intValue
        let owner = json["owner"]["login"].stringValue
        let description = json["description"].stringValue
        let url = json["html_url"].stringValue
        let id = json["id"].intValue
        
        return Repository(name: name, owner: owner, stars: stars, description: description, url: url, id: id)
    }
    
    fileprivate func createQueryStringForFilter(_ filter: SHGithubCreatedFilter?) -> String {
        var queryString = "language:swift"
        if let filter = filter {
            queryString = "\(queryString) \(filter.qualifierString)"
        }
        return queryString
    }
}
