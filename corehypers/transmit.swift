//
//  main.swift
//  console
//
//  Created by yuuji on 6/12/16.
//  Copyright © 2016 yuuji. All rights reserved.
//

import Foundation

let client = try! SXStreamClient(ip: "127.0.0.1", port: 5555, domain: .INET) { (object, data) -> Bool in
    print(String(data: data, encoding:  NSUTF8StringEncoding))
    return true
}

client.start(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), initialPayload: nil)

/* lie, no encryption yet */
func encrypt(command: String) -> NSData {
    
    /* console */
    var count = command.characters.count + 1
    var argc = command.componentsSeparatedByString(" ").filter({!($0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).characters.count == 0)}).count
    var payload = [UInt8](count: count + 2 * sizeof(Int) + 1, repeatedValue: 0)
    NSData(bytes: &count, length: sizeof(Int)).getBytes(&payload, length: sizeof(Int))
    NSData(bytes: &argc, length: sizeof(Int)).getBytes(&payload[sizeof(Int)], length: sizeof(Int))
    payload[2 * sizeof(Int)] = 0x20;
    command.dataUsingEncoding(NSUTF8StringEncoding)!.getBytes(&payload[2 * sizeof(Int) + 1], length: sizeof(Int))
    print(payload.count)
    
    return NSData(bytes: &payload, length: payload.count)
}


while (true) {
    let string = readLine(stripNewline: true);
    let data = encrypt(string!)
    print(data)
    client.send(data, flags: 0)
}
