//
//  GithubOAuthCred.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

internal class GithubOAuthSettings {
    static var clientID: String {
        get {
            return getKey("client_id")
        }
    }
    static var clientSecret: String {
        get {
            return getKey("client_secret")
        }
    }
    static let callbackURLPrefix = "https://localhost:4567"
    static let codeKey = "code"

    private static func getKey(name: String) -> String {
        var keys: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            return dict[name] as! String
        }
        return ""
    }
}