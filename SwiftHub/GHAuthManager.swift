//
//  GHAuthManager.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 11/14/15.
//  Copyright © 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import AuthenticationViewController
import PromiseKit

enum GHAuthError: ErrorType {
    case FailedToFindView, FailedToReceiveProperToken
}

public struct GHAuthManager {
    
    // MARK: - Basics -
    static func isAuthenticated() -> Bool {
        return Defaults["authenticated"].boolValue
    }
    
    static func tryAuthenticating() -> Promise<Bool> {
        return Promise { fulfill, error in
            
            let authenticationViewController = GithubAuthenticationVC(provider: OAuthGithub(clientId: "", clientSecret: "", scopes: []))
            authenticationViewController.failureHandler = { e in
                error(e)
            }
            authenticationViewController.authenticationHandler = { token in
                guard let token = token["access_token"] as? String else {
                    error(GHAuthError.FailedToReceiveProperToken)
                    return
                }
                
                saveNewAccessToken(token)
                fulfill(true)
                authenticationViewController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                error(GHAuthError.FailedToFindView)
                return
            }
            
            guard let rootVC = appDelegate.window?.rootViewController else {
                error(GHAuthError.FailedToFindView)
                return
            }
            
            rootVC.presentViewController(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    private static func saveNewAccessToken(accessToken: String) {
        Defaults["authenticated"] = true
        Defaults["token"] = accessToken
        Defaults.synchronize()
    }
    
    static func getToken() -> String {
        return Defaults["token"].stringValue
    }
}