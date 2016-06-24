//
//  GithubOAuthCred.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

internal struct GithubOAuth {
    let clientID: String
    let clientSecret: String
    let callbackURLPrefix = "https://localhost:4567"
    let codeKey = "code"
}