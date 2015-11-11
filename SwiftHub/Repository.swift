//
//  Repository.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation

enum RepositoryError: ErrorType {
    case DeserializationFailed
}

struct Repository: Equatable {
    var name: String
    var owner: String
    var stars: Int
    var description: String
    var url: NSURL
    
    init(name: String, owner: String, stars: Int, description: String, url: String) {
        self.name = name
        self.owner = owner
        self.stars = stars
        self.description = description
        self.url = NSURL(string: url)!
    }
    
    init(serialized: NSData) throws {
        guard let dict = NSKeyedUnarchiver.unarchiveObjectWithData(serialized) as? [String: AnyObject] else {
            throw RepositoryError.DeserializationFailed
        }
        
        guard let name = dict["name"] as? String, let owner = dict["owner"] as? String, let stars = dict["stars"] as? Int, let description = dict["description"] as? String, let urlString = dict["urlString"] as? String else {
            throw RepositoryError.DeserializationFailed
        }
        
        self.name = name
        self.owner = owner
        self.stars = stars
        self.description = description
        
        guard let url = NSURL(string: urlString) else {
            throw RepositoryError.DeserializationFailed
        }
        
        self.url = url
    }
    
    var serialized: NSData {
        let values: [String: AnyObject] = [
            "name": name,
            "owner": owner,
            "stars": stars,
            "description": description,
            "urlString": url.absoluteString
        ]
        return NSKeyedArchiver.archivedDataWithRootObject(values)
    }
}

func ==(lhs: Repository, rhs: Repository) -> Bool {
    return lhs.name == rhs.name && lhs.owner == rhs.owner && lhs.stars == rhs.stars && lhs.description == rhs.description && lhs.url == rhs.url
}

