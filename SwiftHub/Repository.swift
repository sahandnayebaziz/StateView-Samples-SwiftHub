//
//  Repository.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

struct Repository: Equatable, Hashable {
    var name: String
    var owner: String
    var stars: Int
    var description: String
    var url: URL
    var id: Int
    
    init(name: String, owner: String, stars: Int, description: String, url: String, id: Int) {
        self.name = name
        self.owner = owner
        self.stars = stars
        self.description = description
        self.url = URL(string: url)!
        self.id = id
    }
    
    init(serialized: NSData) throws {
        guard let dict = NSKeyedUnarchiver.unarchiveObject(with: serialized as Data) as? [String: AnyObject] else {
            throw RepositorySerializationError.deserializationFailed
        }
        
        guard let name = dict["name"] as? String, let owner = dict["owner"] as? String, let stars = dict["stars"] as? Int, let description = dict["description"] as? String, let urlString = dict["urlString"] as? String, let id = dict["id"] as? Int, let url = URL(string: urlString) else {
            throw RepositorySerializationError.deserializationFailed
        }
        
        self.name = name
        self.owner = owner
        self.stars = stars
        self.description = description
        self.url = url
        self.id = id
    }
    
    var serialized: NSData {
        let values: [String: AnyObject] = [
            "name": name as AnyObject,
            "owner": owner as AnyObject,
            "stars": stars as AnyObject,
            "description": description as AnyObject,
            "urlString": url.absoluteString as AnyObject,
            "id": id as AnyObject
        ]
        return NSKeyedArchiver.archivedData(withRootObject: values) as NSData
    }
    
    var hashValue: Int {
        return id.hashValue
    }
}

func ==(lhs: Repository, rhs: Repository) -> Bool {
    return lhs.name == rhs.name && lhs.owner == rhs.owner && lhs.stars == rhs.stars && lhs.description == rhs.description && lhs.url == rhs.url && lhs.id == rhs.id
}

