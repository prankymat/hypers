//
//  main.swift
//  ShellKit
//
//  Created by yuuji on 6/8/16.
//  Copyright © 2016 yuuji. All rights reserved.
//

import Foundation
import Darwin


enum DarwinFileTypes: Int32 {
    case Unknow = 0
    case NamedPipe = 1
    case CharacterDevice = 2
    case Directory = 4
    case BlockDevice = 6
    case Regular = 8
    case SymbolicLink = 10
    case Socket = 12
    case WhiteOut = 14
}

private extension Array {
    private func combine<T: CustomStringConvertible>(strings: [T]) -> String {
        var t = ""
        for s in strings {
            t.appendContentsOf(s.description)
        }
        return t
    }
}

private extension String {
 
    static func alignedText(strings: String..., spaces: [Int]) -> String {

        let astr = strings.enumerate().map { (index, string) -> String in
            var temp = string
            let space_to_insert = spaces[index] - string.characters.count
            for _ in 0 ..< space_to_insert {
                temp.append(Character(" "))
            }
            return temp
        }
        return strings.combine(astr)
    }
}

func isdigit(char: Character) -> Bool {
    switch char {
    case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
        return true
    default:
        return false
    }
}

func sprintf(format: CustomStringConvertible, _ args: CustomStringConvertible...) -> String {
    return sprintff(format.description, args: args.map({$0.description}))
}

func sprintff(format: String, args: [String]) -> String {
    var tmp = ""
    var i = 0
    var j = 0
    func getc() -> Character { return format[format.startIndex.advancedBy(i)] }
    while i < format.characters.count {
        var c = getc()
        
        switch c {
        case "%":
            
            i += 1
            c = getc() // eat %
            
            var num = ""
            var pad = 0
            
            while (isdigit(c) || c == "@") {
                
                if c == "%" {
                    tmp.append(c)
                    break
                }
                
                if isdigit(c) {
                    repeat {
                        num.append(c)
                        i += 1
                        c = getc()
                    } while isdigit(c)
                    
                    pad = Int(num)!
                }
                
                if c == "@" {
                    
                    tmp.appendContentsOf(args[j])
                    
                    if pad > 0 {
                        let space_to_insert = pad - args[j].characters.count
                        
                        if space_to_insert > 0 {
                            for _ in 0..<space_to_insert {
                                tmp.appendContentsOf(" ")
                                
                            }
                        }
                    }
                    
                    j += 1
                    i += 1
                    c = getc()
                    
                    fallthrough
                }
            }
        default:
            tmp.append(c)
        }
        
        i += 1
    }
    return tmp
}

func printf(format: CustomStringConvertible, args: CustomStringConvertible...) {
    print(sprintff(format.description, args: args.map({$0.description})))
}

func aprintf(format: String, _ args: String...) {
    print(sprintff(format, args: args.map({$0})))
}

struct Dirent: CustomStringConvertible {
    var name: String
    var ino: UInt64
    var size: Int
    var type: DarwinFileTypes
    
    init(d: dirent) {
        var dirent = d
        self.name = String(CString: UnsafeMutablePointer<CChar>(getpointer(&(dirent.d_name))), encoding: NSUTF8StringEncoding)!
        self.size = Int(dirent.d_reclen)
        self.type = DarwinFileTypes(rawValue: Int32(dirent.d_type))!
        self.ino = dirent.d_ino
    }
    
    var description: String {
        get {
            return String.alignedText( name, "\(ino)", "\(size)", "\(type)", spaces: [25, 10, 7, 15])
        }
    }
}

func ls(path: String = ".") -> [Dirent] {

    let dfd = opendir(path.cStringUsingEncoding(NSASCIIStringEncoding)!)
    var dirs = [Dirent]()
    
    var dir :UnsafeMutablePointer<dirent> = nil
   
    repeat {
        dir = readdir(dfd)
        if dir != nil {
            let ad = dir.memory
            dirs.append(Dirent(d: ad))
        }
    } while (dir != nil)
    
    return dirs
}