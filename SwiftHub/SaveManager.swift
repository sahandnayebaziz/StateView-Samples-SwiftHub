//
//  SaveManager.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/11/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct SaveManager {
    
    static private var defaultsKeyForSavedRepos = "saved_repos"
    
    static func saveRepo() {
        
    }
    
    static func deleteRepo() {
        
    }
    
    private static func updateSavedData() {
        
    }
    
    private static func getSavedData() -> [Repository] {
        guard let data = Defaults[defaultsKeyForSavedRepos].data else {
            return []
        }
        
        return []
    }
    
}
