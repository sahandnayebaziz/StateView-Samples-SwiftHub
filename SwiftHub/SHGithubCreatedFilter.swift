//
//  SHGithubCreatedFilter.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/23/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation
import AFDateHelper

enum SHGithubCreatedFilter: String, SHGitHubFilter {
    case LastWeek, LastMonth, LastYear
    
    var qualifierString: String {
        switch self {
        case .LastWeek:
            return "created:>=\(createDateStringForDaysAgo(7))"
        case .LastMonth:
            return "created:>=\(createDateStringForDaysAgo(30))"
        case .LastYear:
            return "created:>=\(createDateStringForDaysAgo(365))"
        }
    }
    
    var prettyString: String {
        switch self {
        case .LastWeek:
            return "Last week"
        case .LastMonth:
            return "Last month"
        case .LastYear:
            return "Last year"
        }
    }
    
    private func createDateStringForDaysAgo(days: Int) -> String {
        return NSDate().dateBySubtractingDays(days).toString(format: .Custom("YYYY-MM-dd"))
    }
}