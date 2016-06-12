//
//  GithubManager.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import Foundation

enum GithubManagerError: ErrorType {
    case NotAuthed
    case OtherError
}

class GithubManager: GithubLoginCallbackDelegate {
    private var accessToken: String? {
        didSet {
            try! GithubManager.sharedManager.fetchUserGithubProjects { (projects) in
                if let projects = projects {
                    ProjectsManager.sharedManager.projects += projects
                }
            }
        }
    }

    static let sharedManager = GithubManager()

    var isAuthenticated: Bool {
        get {
            return accessToken != nil
        }
    }

    func fetchUserGithubProjects(callback: (projects: [Project]?)->()) throws {
        try makeGithubRequest("GET", endpoint: "user/repos") { (success, data) in
            print(success, data)
            if success, let data = data {
                var dict: [AnyObject] = Array()
                do {
                    dict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [AnyObject]
                } catch {
                    print("error")
                }

                var projects = [Project]()
                for repo in dict {
                    let projectJSON = repo as! [String: AnyObject]
                    let projectName = projectJSON["name"] as! String
                    let projectURL = projectJSON["url"] as! String
                    let project = Project(name: projectName, githubURL: NSURL(string: projectURL)!)
                    projects.append(project)
                }
                callback(projects: projects)
            }
        }
    }

    func makeGithubRequest(verb: String, endpoint: String, callback: (success: Bool, data: NSData?)->()) throws {
        guard let accessToken = accessToken else {
            throw GithubManagerError.NotAuthed
        }

        guard let url = NSURL(string: endpoint, relativeToURL: NSURL(string: "https://api.github.com")!) else {
            fatalError("Endpoint '\(endpoint)' is invalid")
        }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = verb
        request.addValue(" token " + accessToken, forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            print("here")
            if error != nil || (response as! NSHTTPURLResponse).statusCode != 200 {
                callback(success: false, data: data)
            } else {
                callback(success: true, data: data)
            }
        }.resume()
    }

    func didFinishGithubLogin(success success: Bool, code: String) {
        let accessTokenURL = NSURL(string: "https://github.com/login/oauth/access_token?"
                                          + "client_id=" + GithubOAuthSettings.clientID + "&"
                                          + "client_secret=" + GithubOAuthSettings.clientSecret + "&"
                                          + "code=" + code)!

        let accessTokenRequest = NSMutableURLRequest(URL: accessTokenURL)
        accessTokenRequest.HTTPMethod = "POST"

        NSURLSession.sharedSession().dataTaskWithRequest(accessTokenRequest) { (data, _, _) in
            if let data = data {
                let responseString = String(data: data, encoding: NSUTF8StringEncoding)!
                self.accessToken = responseString.URLStringParams["access_token"]
            }
        }.resume()
    }
}