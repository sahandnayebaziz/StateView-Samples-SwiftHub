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

struct Repository: Equatable, Hashable {
    var name: String
    var owner: String
    var stars: Int
    var description: String
    var url: NSURL
    var id: Int
    
    init(name: String, owner: String, stars: Int, description: String, url: String, id: Int) {
        self.name = name
        self.owner = owner
        self.stars = stars
        self.description = description
        self.url = NSURL(string: url)!
        self.id = id
    }
    
    init(serialized: NSData) throws {
        guard let dict = NSKeyedUnarchiver.unarchiveObjectWithData(serialized) as? [String: AnyObject] else {
            throw RepositoryError.DeserializationFailed
        }
        
        guard let name = dict["name"] as? String, let owner = dict["owner"] as? String, let stars = dict["stars"] as? Int, let description = dict["description"] as? String, let urlString = dict["urlString"] as? String, let id = dict["id"] as? Int else {
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
        self.id = id
    }
    
    var serialized: NSData {
        let values: [String: AnyObject] = [
            "name": name,
            "owner": owner,
            "stars": stars,
            "description": description,
            "urlString": url.absoluteString,
            "id": id
        ]
        return NSKeyedArchiver.archivedDataWithRootObject(values)
    }
    
    var hashValue: Int {
        return id.hashValue
    }
}

func ==(lhs: Repository, rhs: Repository) -> Bool {
    return lhs.name == rhs.name && lhs.owner == rhs.owner && lhs.stars == rhs.stars && lhs.description == rhs.description && lhs.url == rhs.url && lhs.id == rhs.id
}

