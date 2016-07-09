//
//  ChangeTrackerTests.swift
//  hypers
//
//  Created by Matthew Wo on 7/8/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import XCTest

@testable import hypers

// MARK: Helpers
enum ContainerLanguage {
    case C
    case JS

    func rawValue() -> String {
        switch self {
        case .C:
            return "C"
        case .JS:
            return "JS"
        }
    }

    static let allLangs: [ContainerLanguage] = [.C, .JS]
}

enum ContainerCondition {
    case ValidSyntax
    case InvalidSyntax
    case Empty
    case Custom(String)

    func rawValue() -> String {
        switch self {
        case .ValidSyntax:
            return "Valid"
        case .InvalidSyntax:
            return "Invalid"
        case .Empty:
            return "Empty"
        case .Custom(_):
            return "Custom"
        }
    }
}

struct SnippetCase {
    let name: String
    let snippet: String
}

class TestContainers {
    func contentsOf(file: String) -> String {
        let contents = NSFileManager.defaultManager().contentsAtPath(file)!
        return String(data: contents, encoding: NSUTF8StringEncoding)!
    }

    func generateLines(for lang: ContainerLanguage, condition: ContainerCondition) -> [SnippetCase] {
        func getDict(from file: String) -> NSDictionary {
            var keys: NSDictionary?
            if let path = NSBundle(forClass: self.dynamicType).pathForResource(file, ofType: "plist") {
                keys = NSDictionary(contentsOfFile: path)
            }
            return keys!
        }

        switch (lang, condition) {
        case (_, .Custom(let str)):
            return [SnippetCase(name: "\(condition.rawValue())\(lang.rawValue())", snippet: str)]
        case (_, .Empty):
            return [SnippetCase(name: "\(condition.rawValue())\(lang.rawValue())", snippet: "")]
        default:
            let dict = getDict(from: "\(condition.rawValue())\(lang.rawValue())")
            var cases = [SnippetCase]()
            for (key, val) in dict {
                cases.append(SnippetCase(name: key as! String, snippet: val as! String))
            }
            return cases
        }
    }

    func snippetCases(withCondition condition: ContainerCondition, for lang: ContainerLanguage) -> [SnippetCase] {
        return generateLines(for: lang, condition: condition)
    }

    func generateSnippets(withCondition condition: ContainerCondition) -> [SnippetCase] {
        var containers = [SnippetCase]()
        for lang in ContainerLanguage.allLangs {
            let snippets = snippetCases(withCondition: condition, for: lang)
            containers.appendContentsOf(snippets)
        }
        return containers
    }
}

// MARK: Test cases
class ChangeTrackerTests: XCTestCase {
    let ValidSnippetCases = TestContainers().generateSnippets(withCondition: .ValidSyntax)
    let InvalidSnippetCases = TestContainers().generateSnippets(withCondition: .InvalidSyntax)

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
