//
//  ProjectsManager.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

class Project: NSObject {
    var name: String
    var downloaded: Bool {
        get {
            return self.filePath != nil && self.filePath!.absoluteString.isEmpty == false
        }
    }
    var filePath: NSURL? = nil
    var githubURL: NSURL

    init(name: String, githubURL: NSURL) {
        self.name = name
        self.githubURL = githubURL
    }

    convenience init(name: String, githubURL: NSURL, filePath: NSURL) {
        self.init(name: name, githubURL: githubURL)
        self.filePath = filePath
    }

    private let nameKey = "name"
    private let filePathKey = "filePath"
    private let githubURLKey = "githubURL"

    required init?(coder aDecoder: NSCoder) {  // may return nil when constructing
        name = aDecoder.decodeObjectForKey(nameKey) as! String
        githubURL = aDecoder.decodeObjectForKey(githubURLKey) as! NSURL
        filePath = aDecoder.decodeObjectForKey(filePathKey) as? NSURL
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: nameKey)
        aCoder.encodeObject(githubURL, forKey: githubURLKey)
        if let filePath = filePath {
            aCoder.encodeObject(filePath, forKey: filePathKey)
        }
    }
}

class ProjectsManager {
    static let sharedManager = ProjectsManager()

    // !!! Dummy data
    var projects = [Project(name: "Project 1", githubURL: NSURL(string: "https://google.com")!),
                    Project(name: "Project 2", githubURL: NSURL(string: "https://google.com")!, filePath: NSURL(string: "file://Documents/somewhere")!)]

    //    var projects = [Project]()  // Replace with this in production


    var archivePath: String? {
        get {
            let directoryList = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

            if let documentsPath = directoryList.first {
                return documentsPath + "/ProjectsList"
            }

            assertionFailure("Couldn't determine where to save file")
            return nil
        }
    }

    func saveProjectsList() {
        guard let theArchivePath = archivePath else {
            assertionFailure("unable to find archivePath")
            return
        }

        if NSKeyedArchiver.archiveRootObject(projects, toFile: theArchivePath) {
            print("Saved!")
        } else {
            assertionFailure("Couldn't save to \(theArchivePath)")
        }
    }

    init() {
        guard let theArchivePath = archivePath else {
            assertionFailure("unable to find archivePath")
            return
        }

        if NSFileManager.defaultManager().fileExistsAtPath(theArchivePath) {
            projects = NSKeyedUnarchiver.unarchiveObjectWithFile(theArchivePath) as! [Project]
        }
    }

}