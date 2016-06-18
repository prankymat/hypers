//
//  SyntaxHighlighter.swift
//  hypers
//
//  Created by Matthew Wo on 6/17/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

enum SyntaxHighlightFileType {
    case cpp
}

enum TokenType {
    case Function
    case Decorator  // int, string
    case Header     // #include <iostream>
    case Literal    // "my name", 123, 321.4
    case Operator   // +=, ++, --, -, +, *

}

struct SyntaxToken {
    let type: TokenType
    let range: NSRange
}

private class TokensCacher {
    static let sharedCacher = TokensCacher(size: 1000)

    private var cache = [String : [SyntaxToken]]()
    private let size: Int

    init(size: Int) {
        self.size = size
    }

    func cacheTokens(tokens: [SyntaxToken], forString origStr: String) {
        if cache.count >= size {
            cache.popFirst()
        }

        cache[origStr] = tokens
    }

    func retrieveCachedTokens(forStr origStr: String) -> [SyntaxToken]? {
        return cache[origStr]
    }
}

private class TokenGenerator {
    func parseString(string: String) -> [SyntaxToken] {
        if let result = TokensCacher.sharedCacher.retrieveCachedTokens(forStr: string) {
            return result
        }


    }
}

class SyntaxHighlighter {
    let fileType: SyntaxHighlightFileType
    init(fileType: SyntaxHighlightFileType) {
        self.fileType = fileType
    }


}