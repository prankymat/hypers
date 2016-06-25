//
//  GithubOAuthCred.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

struct GithubSettings {
    static let OAuth: GithubOAuth = {
        func get(key name: String) -> String {
            var keys: NSDictionary?
            if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
                keys = NSDictionary(contentsOfFile: path)
            }
            if let dict = keys {
                return dict[name] as! String
            }
            return ""
        }

        return GithubOAuth(clientID: get(key: "client_id"), clientSecret: get(key: "client_secret"))
    }()
}

struct GithubOAuth {
    let clientID: String
    let clientSecret: String
    let callbackURLPrefix = "https://localhost:4567"
    let codeKey = "code"
}

