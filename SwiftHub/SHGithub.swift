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
    
    private var nextPageToCache = 0
    private var cachedRepositories: [Repository] = []
    
    func getRepositories(cachedOnly: Bool, atPage: Int?, receiver: SHGithubDataReceiver?) -> [Repository] {
        if cachedOnly {
            return cachedRepositories
        } else {
            if let page = atPage, receiver = receiver {
                if page >= nextPageToCache {
                    getRepositoriesFromGithub(page, receiver: receiver)
                    self.nextPageToCache = page + 1
                }
            }
        }
        
        return cachedRepositories
    }
    
    private func getRepositoriesFromGithub(atPage: Int, receiver: SHGithubDataReceiver) {
        var urlParams = parameters
        urlParams["q"] = "language:swift"
        print("getting repos")
        
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
                
                for repo in repos {
                    self.cachedRepositories.append(repo)
                }
                receiver.receiveNewRepos(repos)
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
}