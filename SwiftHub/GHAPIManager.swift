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
import AFDateHelper
import PromiseKit
import BRYXBanner

struct GHAPIManager {
    
    static func downloadRepositories(delegate: MainTableViewController, atPage: Int, withFilters filters: [RepositoriesFilter]?) {
        
        var URLParameters: [String: String] = [
            "sort":"stars",
            "order":"desc",
            "page":"\(atPage)"
        ]
        
        let swiftLanguageQualifier = "language:swift"
        var otherQualifiers = ""
        if let filters = filters {
            for filter in filters {
                otherQualifiers = "\(otherQualifiers) \(filter.qualifier)"
            }
        }
        
        URLParameters["q"] = "\(swiftLanguageQualifier)\(otherQualifiers)"
        
        
        updateNetworkActivityIndicatorForActiveState(true)
        
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: URLParameters)
            .validate()
            .responseJSON { response in
                guard let data = response.result.value else {
                    print(response.result.error)
                    return
                }
                
                var json = JSON(data)
                let numberOfReposFound = json["items"].array!.count
                
                for repoIndex in 0...numberOfReposFound - 1 {
                    let repoRaw = json["items"][repoIndex]
                    let name = repoRaw["name"].stringValue
                    let stars = repoRaw["stargazers_count"].intValue
                    let owner = repoRaw["owner"]["login"].stringValue
                    let description = repoRaw["description"].stringValue
                    let url = repoRaw["html_url"].stringValue
                    
                    let repo = Repository(name: name, owner: owner, stars: stars, description: description, url: url)
                    dispatch_to_main_queue {
                        delegate.insertNewRepo(repo)
                    }
                }
                
                updateNetworkActivityIndicatorForActiveState(false)
        }
    }
    
    static func getRepositories(withFilters filters: [RepositoriesFilter]) -> Promise<[Repository]> {
        return Promise { fulfill, reject in
            var URLParameters: [String: String] = [ // TODO: allow a different sort?
                "sort":"stars",
                "order":"desc"
            ]
            
            let swiftLanguageQualifier = "language:swift"
            var otherQualifiers = ""
            for filter in filters {
                otherQualifiers = "\(otherQualifiers) \(filter.qualifier)"
            }
            URLParameters["q"] = "\(otherQualifiers)\(swiftLanguageQualifier)"
            
            updateNetworkActivityIndicatorForActiveState(true)
            
            Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: URLParameters)
                .validate()
                .responseJSON { response in
                    guard let data = response.result.value else {
                        if let error = response.result.error {
                            reject(error)
                        }
                        return
                    }
                    
                    var json = JSON(data)
                    let numberOfReposFound = json["items"].array!.count
                    var repos: [Repository] = []
                    
                    if numberOfReposFound > 0 {
                        for repoIndex in 0...numberOfReposFound - 1 {
                            let repoRaw = json["items"][repoIndex]
                            let name = repoRaw["name"].stringValue
                            let stars = repoRaw["stargazers_count"].intValue
                            let owner = repoRaw["owner"]["login"].stringValue
                            let description = repoRaw["description"].stringValue
                            let url = repoRaw["html_url"].stringValue
                            
                            let repo = Repository(name: name, owner: owner, stars: stars, description: description, url: url)
                            repos.append(repo)
                        }
                    }
                    
                    updateNetworkActivityIndicatorForActiveState(false)
                    fulfill(repos)
            }

        }
    }
    
    static func createDateQualifiers() -> [RepositoriesFilter] {
        var filters: [RepositoriesFilter] = []
        
        filters.append(createDateFilterForDaysAgo(7, filterName: "Last week"))
        filters.append(createDateFilterForDaysAgo(30, filterName: "Last month"))
        filters.append(createDateFilterForDaysAgo(365, filterName: "Last year"))
        filters.append(RepositoriesFilter(name: "All time", type: .Date, qualifier: ""))
        
        return filters
    }
    
    static func defaultQualifiers() -> [RepositoriesFilter] {
        var filters: [RepositoriesFilter] = []
        
        filters.append(createDateFilterForDaysAgo(7, filterName: "Last week"))
        
        return filters
    }
    
    private static func createDateFilterForDaysAgo(days: Int, filterName: String) -> RepositoriesFilter {
        let dateAsString = NSDate().dateBySubtractingDays(days).toString(format: .Custom("YYYY-MM-dd"))
        return RepositoriesFilter(name: filterName, type: .Date, qualifier: "created:>=\(dateAsString)")
    }
    
    private static func updateNetworkActivityIndicatorForActiveState (active: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = active
    }
}








