//
//
//  Created by Yuji on 6/19/16.
//  Copyright © 2016 YS. All rights reserved.
//

import Foundation

#if !swift(>=3)
    
    struct CharacterSet : RawRepresentable {
        static let newlines = CharacterSet(rawValue: NSCharacterSet.newlineCharacterSet())
        
        var rawValue: NSCharacterSet
    }
    extension String {
        mutating func append(aString: String) {
            self.appendContentsOf(aString)
        }
        
        func index(start: Index, offsetBy distance: Int) -> Index {
            return self.startIndex.advancedBy(distance)
        }
        
        func components(separatedBy str: String) -> [String] {
            return self.componentsSeparatedByString(str)
        }
        
        func components(separatedBy set: CharacterSet) -> [String] {
            return self.componentsSeparatedByCharactersInSet(set.rawValue)
        }
        
        func substring(with range: Range<Index>) -> String {
            return self.substringWithRange(range)
        }
        
    }
    
    extension Array {
        func enumerated() -> EnumerateSequence<Array> {
            return self.enumerate()
        }
        
        mutating func removeSubrange (_ range: Range<Int>) {
            self.removeRange(range)
        }
        
        mutating func insert(_ item: Element, at index: Int) {
            self.insert(item, at: index)
        }
    }
    
    extension Range {
        var lowerBound: Index {
            return self.endIndex
        }
        
        var upperBound: Index {
            return self.startIndex
        }
    }
#endif

struct Line {
    var text: String
    var numberOfCharacters: Int {
        return text.characters.count
    }
    
    var scopeCount: Int = 0
    
    // For C-like functions, For python, this will be 4 spaces
    // For html, this will be <anything> to increment and </anything> to decrement
    mutating func countScope() -> Int {
        var i = 0
        for char in self.text.characters {
            if char == "{" {
                i += 1
            } else if char == "}" {
                i -= 1
            }
        }
        self.scopeCount = i
        return i
    }
    
    static func combine(lines lines: [Line]) -> String {
        var tmp = ""
        for line in lines {
            tmp.append("\(line.text)\n")
        }
        return tmp
    }
    
    init(text: String) {
        self.text = text
    }
}

struct LineContainer: CustomStringConvertible {
    var lines = [Line]()
    var scopeSums = [Int]()
    
    var description: String {
        return Line.combine(lines: self.lines)
    }
    
    func scopeCountSum(atLine index: Int) -> Int {
        return lines.map({$0.scopeCount}).reduce(0) {$0 + $1}
    }
    
    mutating func didDeletedText(inRange range: NSRange) {
        var i = 0
        var ilength = 0
        
        var newLineString = ""
        
        for (index, line) in lines.enumerated() {
            ilength += line.numberOfCharacters
            if !(ilength < range.location) {
                i = index
                let end = line.text.index(line.text.startIndex,
                                          offsetBy: range.location - ilength + line.numberOfCharacters - index)
                newLineString.append(line.text.substring(with:Range(line.text.startIndex..<end)))
                break
            }
        }
        
        var j = i
        
        repeat {
            ilength += lines[j + 1].numberOfCharacters
            
            if (ilength < range.location + range.length) {
                j += 1
            }
            
        } while ilength < range.location + range.length
        
        
        let start = lines[j].text.index(lines[j].text.endIndex,
                                        offsetBy: -1 * (ilength - (range.location + range.length)) + (j - i - 1))
        newLineString.append(lines[j].text.substring(with:Range(start..<lines[j].text.endIndex)))

        self.lines.removeSubrange(Range(i..<j))
        self.lines.insert(Line(text: newLineString), at: i)
        self.scopeSums[i] = scopeCountSum(atLine: i)
    }
    
    func affectedLines(inRange range: NSRange) -> Range<Int> {

        var i = 0
        var ilength = 0
        
        for (index, line) in lines.enumerated() {
            ilength += line.numberOfCharacters
            if !(ilength < range.location) {
                i = index
                break
            }
        }
        
        var j = i
        
        repeat {
            ilength += lines[j + 1].numberOfCharacters
            
            if (ilength < range.location + range.length) {
                j += 1
            }
            
        } while ilength < range.location + range.length
        
        return Range(i..<j)
    }
    
    func linesToReparseforTextChanged(inRange range: Range<Int>) -> Range<Int> {
        let beginningScope = min(scopeSums[range.lowerBound], scopeSums[range.upperBound - 1])
        
        var endScope = beginningScope
        /* if the line contains a scope, we need to find the upper one*/
        if self.lines[range.lowerBound].scopeCount != 0 {
            
            endScope = beginningScope == 0 ? 0 : beginningScope - 1
        }
        
        var lowerScope = range.lowerBound
        var upperScope = range.upperBound

        while scopeSums[lowerScope] != beginningScope && lowerScope != 0 {
            lowerScope -= 1
        }
        
        while scopeSums[upperScope] != endScope && upperScope != self.lines.count {
            upperScope += 1
        }
        return Range(lowerScope..<upperScope)
    }
    
    init(withText text: String) {
        let lines = text.components(separatedBy: .newlines)
        for (i, line) in lines.enumerated() {
            self.lines.append(Line(text: line))
            _ = self.lines[i].countScope()
            scopeSums.append(scopeCountSum(atLine: i))
        }
        
    }
}

