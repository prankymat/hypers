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

    private enum ProjectKeys: String {
        case name = "name"
        case filePath = "filePath"
        case githubURLKey = "githubURL"
    }

    required init?(coder aDecoder: NSCoder) {  // may return nil when constructing
        name = aDecoder.decodeObjectForKey(ProjectKeys.name.rawValue) as! String
        githubURL = aDecoder.decodeObjectForKey(ProjectKeys.githubURLKey.rawValue) as! NSURL
        filePath = aDecoder.decodeObjectForKey(ProjectKeys.filePath.rawValue) as? NSURL
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: ProjectKeys.name.rawValue)
        aCoder.encodeObject(githubURL, forKey: ProjectKeys.githubURLKey.rawValue)
        if let filePath = filePath {
            aCoder.encodeObject(filePath, forKey: ProjectKeys.filePath.rawValue)
        }
    }
}

class ProjectsManager {
    static let sharedManager = ProjectsManager()

    var projects = [Project]() {
        didSet {
            if projects.isEmpty == false {
                saveProjectsList()
            }
        }
    }

    private var archivePath: String? {
        get {
            let directoryList = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

            if let documentsPath = directoryList.first {
                return documentsPath + "/ProjectsList"
            }

            assertionFailure("Couldn't determine where to save file")
            return nil
        }
    }

    private func saveProjectsList() {
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