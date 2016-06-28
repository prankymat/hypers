//
//  NSURL+params.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

extension NSURL {
    var params: [String : String] {
        get {
            let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
            var items = [String: String]()
            for item in urlComponents?.queryItems ?? [] {
                items[item.name] = item.value ?? ""
            }
            if items[""] == "" && items.count == 1 {
                return [String: String]()
            }
            return items
        }
    }
}

extension String {
    var urlAPIComponents: [String : String]? {
        guard NSURL(string: self) != nil else {return nil}
        guard let s = self.rangeOfString("?") else {return nil}
        
        var ret = [String : String]()
        let str = self.substringWithRange(s.endIndex..<self.endIndex)
        
        for att in str.componentsSeparatedByString("&") {
            let keyvalue = att.componentsSeparatedByString("=")
            guard keyvalue.count == 2 else {return nil}
            ret[keyvalue[0]] = keyvalue[1]
        }
        
        return ret
    }
}