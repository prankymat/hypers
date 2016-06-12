//
//  NSURL+params.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

extension NSURL {
    var params: [String: String] {
        get {
            let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
            var items = [String: String]()
            for item in urlComponents?.queryItems ?? [] {
                items[item.name] = item.value ?? ""
            }
            return items
        }
    }
}

extension String {
    var URLStringParams: [String: String] {
        get {
            let url = NSURL(string: "http://a.com?" + self)!
            let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
            var items = [String: String]()
            for item in urlComponents?.queryItems ?? [] {
                items[item.name] = item.value ?? ""
            }
            return items
        }
    }
}