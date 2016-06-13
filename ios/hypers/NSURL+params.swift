//
//  NSURL+params.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

struct WebAPIAttribute {
    var `protocol`: String // for example: http
    var att: [String: String]
}
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
    
    
    var urlAPIComponents: WebAPIAttribute? {
        guard let pos = self.rangeOfString("://") else {return nil}
        guard let s = self.rangeOfString("?") else {return nil}
        
        let `protocol` = self.substringWithRange(self.startIndex..<pos.startIndex)
        
        var ret = WebAPIAttribute(protocol: `protocol`, att: [:])
        let str = self.substringWithRange(s.endIndex..<self.endIndex)
        
        for att in str.componentsSeparatedByString("&") {
            let keyvalue = att.componentsSeparatedByString("=")
            ret.att[keyvalue[0]] = keyvalue[1]
        }
        
        return ret
    }
    
    var urlAPIAttributes: [String: String]? {
        guard let s = self.rangeOfString("?") else {return nil}
        
        var ret = [String: String]()
        let str = self.substringWithRange(s.endIndex..<self.endIndex)
        
        for att in str.componentsSeparatedByString("&") {
            let keyvalue = att.componentsSeparatedByString("=")
            ret[keyvalue[0]] = keyvalue[1]
        }
        return ret
    }
}