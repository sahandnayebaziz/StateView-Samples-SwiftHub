//
//  SHGithubFilter.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/23/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import Foundation
import AFDateHelper

enum SHGithubFilterType: String {
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
    
    private func createDateStringForDaysAgo(days: Int) -> String {
        return NSDate().dateBySubtractingDays(days).toString(format: .Custom("YYYY-MM-dd"))
    }
}