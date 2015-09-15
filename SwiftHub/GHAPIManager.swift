//
//  GHAPIManager.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GHAPIManager {
    
    static func downloadRepositories(delegate: MainTableViewController, atPage: Int) {
        let URLParameters = [
            "q":"language:swift",
            "sort":"stars",
            "order":"desc",
            "page":"\(atPage)"
        ]
        
        updateNetworkActivityIndicatorForActiveState(true)
        
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: URLParameters)
            .validate()
            .responseJSON { _, _, result in
                switch result {
                case .Success:
                    var json = JSON(result.value!)
                    let numberOfReposFound = json["items"].array!.count
                    
                    for repoIndex in 0...numberOfReposFound - 1 {
                        let repoRaw = json["items"][repoIndex]
                        let name = repoRaw["name"].stringValue
                        let stars = repoRaw["stargazers_count"].intValue
                        let owner = repoRaw["owner"]["login"].stringValue
                        let description = repoRaw["description"]["login"].stringValue
                        
                        let repo = Repository(name: name, owner: owner, stars: stars, description: description)
                        dispatch_to_main_queue {
                            delegate.insertNewRepo(repo)
                        }
                    }
                case .Failure(_, let error):
                    print(error)
                }
                
                updateNetworkActivityIndicatorForActiveState(false)
        }
    }
    
    static func downloadReadmeForRepository(repository: String, owner: String, delegate: RepositoryDetailViewController, completion: (()->Void)) {
        
        updateNetworkActivityIndicatorForActiveState(true)
        
        Alamofire.request(.GET, "https://api.github.com/repos/" + owner + "/" + repository + "/readme", parameters: nil)
            .validate()
            .responseJSON { _, _, result in
                switch result {
                case .Success:
                    var json = JSON(result.value!)
                    var readmeData = json["content"].stringValue
                    dispatch_to_main_queue {
                        //delegate.readme = readmeData
                        completion()
                    }
                case .Failure(_, let error):
                    print(error)
                }
                dispatch_to_main_queue {
                    updateNetworkActivityIndicatorForActiveState(false)
                }
        }
    }
    
    static func createDateQualifiers() -> [RepositoriesFilter] {
        var filters: [RepositoriesFilter] = []
        
        filters.append(RepositoriesFilter(name: "Last week", type: "date", qualifier: "created:<2013-01-01"))
        filters.append(RepositoriesFilter(name: "Last month", type: "date", qualifier: "created:<2013-01-01"))
        filters.append(RepositoriesFilter(name: "Last year", type: "date", qualifier: "created:<2013-01-01"))
        
        return filters
    }
    
    private static func updateNetworkActivityIndicatorForActiveState (active: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = active
    }
}








