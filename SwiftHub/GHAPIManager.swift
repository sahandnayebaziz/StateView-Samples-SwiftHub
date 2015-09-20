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
                        let description = repoRaw["description"].stringValue
                        let url = repoRaw["html_url"].stringValue
                        
                        let repo = Repository(name: name, owner: owner, stars: stars, description: description, url: url)
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
    
    static func createDateQualifiers() -> [RepositoriesFilter] {
        var filters: [RepositoriesFilter] = []
        
        filters.append(createDateFilterForDaysAgo(7, filterName: "Last week"))
        filters.append(createDateFilterForDaysAgo(30, filterName: "Last month"))
        filters.append(createDateFilterForDaysAgo(365, filterName: "Last year"))
        filters.append(RepositoriesFilter(name: "All time", type: "date", qualifier: ""))
        
        return filters
    }
    
    static func defaultQualifiers() -> [RepositoriesFilter] {
        var filters: [RepositoriesFilter] = []
        
        filters.append(RepositoriesFilter(name: "All time", type: "date", qualifier: ""))
        
        return filters
    }
    
    private static func createDateFilterForDaysAgo(days: Int, filterName: String) -> RepositoriesFilter {
        let dateAsString = NSDate().dateBySubtractingDays(days).toString(format: .Custom("YYYY-MM-dd"))
        return RepositoriesFilter(name: filterName, type: "date", qualifier: "created:>=\(dateAsString)")
    }
    
    private static func updateNetworkActivityIndicatorForActiveState (active: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = active
    }
}








