//
//  OAuth.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/12/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

// This file contains GithubAuthenticationVC and it's backing data store OAuthGithub.
// Together, they can present Github in a webView and return an access token.

import Foundation
import AuthenticationViewController

struct OAuthGithub: AuthenticationProvider {
    
    let title: String? = "Github"
    let clientId: String = "0c370d5544a190108092"
    let clientSecret: String = "6077628a1f720bc66ed0a4801a6a688a80905e78"
    let scopes: [String] = ["public-repo"]
    
    var authorizationURL: NSURL {
        return NSURL(string:"https://github.com/login/oauth/authorize?client_id=\(clientId)&redirect_uri=swifthub%3A%2F%2Foauth-callback&scope=public-repo")!
    }
    
    var accessTokenURL: NSURL {
        return NSURL(string: "https://github.com/login/oauth/access_token")!
    }
    
    var parameters = [
        "client_id": "0c370d5544a190108092",
        "client_secret": "6077628a1f720bc66ed0a4801a6a688a80905e78",
        "scopes": "public-repo",
        "redirect_uri": "swifthub://oauth-callback"
    ]
    
    // MARK: Initialisers
    init(clientId: String, clientSecret: String, scopes: [String]) {
    }
}

public class GithubAuthenticationVC: AuthenticationViewController {
    public override func authenticateWithCode(code: String) {
        let provider = OAuthGithub(clientId: "", clientSecret: "", scopes: [])
        
        let request = NSMutableURLRequest(URL: provider.accessTokenURL)
        let parameters = provider.parameters.map { key, value in
            "\(key)=\(value)"
            }.joinWithSeparator("&")
        let data = "client_id=\(provider.clientId)&client_secret=\(provider.clientSecret)&code=\(code)&\(parameters)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { [unowned self] (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                
                guard error == .None else {
                    self.failureHandler?(.InvalidRequest(error!))
                    return
                }
                
                guard let httpResponse = response as? NSHTTPURLResponse where 200..<300 ~= httpResponse.statusCode else {
                    self.failureHandler?(.URLResponseError(response!))
                    return
                }
                
                guard let data = data else {
                    self.failureHandler?(.InvalidToken)
                    return
                }
                
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                        self.authenticationHandler?(json)
                    }
                } catch {
                    self.failureHandler?(.URLResponseError(httpResponse))
                }
                
            }
            }.resume()
    }
}