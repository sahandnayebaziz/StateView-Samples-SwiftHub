//
//  DetailViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController, UITextViewDelegate {



    var detailItem: Repository? {
        didSet {
            self.configureView()
        }
    }

    var contentContainer: UIView!
    
    
    
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Repository = self.detailItem {
            title = detail.name
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.automaticallyAdjustsScrollViewInsets = true
        
        let scrollContainer = UIScrollView()
        scrollContainer.userInteractionEnabled = true
        self.view.addSubview(scrollContainer)
        scrollContainer.backgroundColor = UIColor.whiteColor()
        scrollContainer.snp_makeConstraints { make in
            make.top.equalTo(view.snp_top)
            make.bottom.equalTo(view.snp_bottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
        }
        scrollContainer.contentSize = CGSize(width: scrollContainer.frame.size.width, height: 900)

        contentContainer = UIView()
        contentContainer.backgroundColor = UIColor.whiteColor()
        scrollContainer.addSubview(contentContainer)
        contentContainer.snp_makeConstraints { make in
            make.top.equalTo(scrollContainer.snp_top)
            make.width.equalTo(view.snp_width)
            make.centerX.equalTo(view.snp_centerX)
            make.height.equalTo(900)
        }
        

        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

