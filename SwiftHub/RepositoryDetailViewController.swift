//
//  DetailViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import WebKit

class RepositoryDetailViewController: UIViewController, WKNavigationDelegate {



    var detailItem: Repository? {
        didSet {
            self.configureView()
        }
    }

    var contentContainer: UIView!
    var descriptionLabel: UILabel?
    var starsLabel: UILabel?
    var webView: WKWebView?

    
    
    
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Repository = self.detailItem {
            title = detail.name
            descriptionLabel?.text = detail.description
            starsLabel?.text = "\(detail.stars)"
            
            if let URL = detail.url {
                let request = NSURLRequest(URL: URL)
                webView?.loadRequest(request)
            }
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
        
        descriptionLabel = UILabel()
        descriptionLabel!.font = UIFont.systemFontOfSize(13)
        descriptionLabel!.numberOfLines = 3
        contentContainer.addSubview(descriptionLabel!)
        descriptionLabel!.snp_makeConstraints { make in
            make.top.equalTo(contentContainer.snp_top).offset(16)
            make.width.equalTo(contentContainer.snp_width).offset(-112)
            make.left.equalTo(contentContainer.snp_left).offset(16)
        }
        
        starsLabel = UILabel()
        starsLabel!.font = UIFont.systemFontOfSize(13)
        starsLabel!.textAlignment = .Right
        starsLabel!.textColor = UIColor.lightGrayColor()
        contentContainer.addSubview(starsLabel!)
        starsLabel!.snp_makeConstraints { make in
            make.top.equalTo(contentContainer.snp_top).offset(16)
            make.width.equalTo(112)
            make.right.equalTo(contentContainer.snp_right).offset(-16)
        }
        
        webView = WKWebView()
        webView!.backgroundColor = UIColor.purpleColor()
        webView!.layer.cornerRadius = 12
        webView!.clipsToBounds = true
        webView!.allowsBackForwardNavigationGestures = true
        webView!.navigationDelegate = self
        contentContainer.addSubview(webView!)
        webView!.snp_makeConstraints { make in
            make.width.equalTo(contentContainer.snp_width).offset(-32)
            make.top.equalTo(descriptionLabel!.snp_bottom).offset(16)
            make.bottom.equalTo(contentContainer.snp_bottom).offset(-16)
            make.centerX.equalTo(contentContainer.snp_centerX)
        }
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}

