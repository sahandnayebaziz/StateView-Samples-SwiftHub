//
//  FilterAlertViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 12/23/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class FilterAlertViewController: UIAlertController {
    
    var delegate: FilteredDisplayDelegate
    
    init(delegate: FilteredDisplayDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        message="Filter Swift Repositories by their creation date"
        addAction(UIAlertAction(title: "Last Week", style: UIAlertActionStyle.Default) { action in
            self.delegate.shouldUpdateWithFilters([SHGithubCreatedFilter.LastWeek])
            })
        
        addAction(UIAlertAction(title: "Last Month", style: UIAlertActionStyle.Default) { action in
            self.delegate.shouldUpdateWithFilters([SHGithubCreatedFilter.LastMonth])
            })
        
        addAction(UIAlertAction(title: "Last Year", style: UIAlertActionStyle.Default) { action in
            self.delegate.shouldUpdateWithFilters([SHGithubCreatedFilter.LastYear])
            })
        
        addAction(UIAlertAction(title: "All time", style: UIAlertActionStyle.Default) { action in
            self.delegate.shouldUpdateWithFilters([])
            })

        addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { action in
            
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
