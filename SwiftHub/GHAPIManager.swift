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
    
    static func downloadRepositories(delegate: MainTableViewController) {
        let URLParameters = [
            "q":"language:swift",
            "sort":"stars",
            "order":"desc",
        ]
        
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: URLParameters)
            .validate(statusCode: 200..<300)
            .responseJSON{(request, response, json, error) in
                if (error == nil)
                {
                    var json = JSON(json!)
                    var numberOfReposFound = json["items"].array!.count
                    
                    for repoIndex in 0...numberOfReposFound - 1 {
                        let repoRaw = json["items"][repoIndex]
                        let name = repoRaw["name"].stringValue
                        let stars = repoRaw["stargazers_count"].intValue
                        let owner = repoRaw["owner"]["login"].stringValue
                        
                        let repo = Repository(name: name, owner: owner, stars: stars)
                        dispatch_to_main_queue {
                            delegate.insertNewRepo(repo)
                        }
                    }
                }
                else
                {
                    println("HTTP HTTP Request failed: \(error)")
                }
        }
        
    }
}