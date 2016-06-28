//
//  GithubManager.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import UIKit

enum GithubManagerError: ErrorType {
    case NotAuthed
    case OtherError
}

private var accessToken: String?

private class GithubLoginShowModalIfNeedOperation: NSOperation {

    var sender: UIViewController!

    init(sender: UIViewController!) {
        self.sender = sender
    }

    override func main() {
        if accessToken == nil {
            
            
            dispatch_sync(dispatch_get_main_queue(), {
       
                guard let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController,
                    let loginVC = rootVC.storyboard?.instantiateViewControllerWithIdentifier("GithubLoginViewControllerNav") else {
                        self.cancel()  // abort operation queue! Something wrong has happened.
                        return
                }
                
                loginVC.modalPresentationStyle = .FormSheet
                
                self.sender.presentViewController(loginVC, animated: true, completion: nil)
                
            })
            
            while accessToken == nil {
                /* wait */
            }
            
        }
    }
}

private class GithubFetchUserGithubProjectsOperation: NSOperation {

    var callback: (success: Bool, projects: [Project]?)->()

    init(callback: (success: Bool, projects: [Project]?)->()) {
        self.callback = callback
    }

    override func main() {
        let requestOperation = GithubMakeGithubRequestOperation(verb: "GET", endpoint: "user/repos") { (success, data) in
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
                self.callback(success: true, projects: projects)
            }
        }

        NSOperationQueue.init().addOperation(requestOperation)
    }
}

private class GithubMakeGithubRequestOperation: NSOperation {
    var verb: String
    var endpoint: String
    var callback: (success: Bool, data: NSData?)->()

    init(verb: String, endpoint: String, callback: (success: Bool, data: NSData?)->()) {
        self.verb = verb
        self.endpoint = endpoint
        self.callback = callback
    }

    override func main() {
        guard let accessToken = accessToken else {
            fatalError("GitHub access token cannot be nil")
        }

        guard let url = NSURL(string: endpoint, relativeToURL: NSURL(string: "https://api.github.com")!) else {
            fatalError("Endpoint '\(endpoint)' is invalid")
        }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = verb
        request.addValue(" token " + accessToken, forHTTPHeaderField: "Authorization")
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if error != nil || (response as! NSHTTPURLResponse).statusCode != 200 {
                self.callback(success: false, data: data)
            } else {
                self.callback(success: true, data: data)
            }
        }.resume()
    }
}


class GithubManager {

    static let sharedManager = GithubManager()

    private let OAuthSettings = GithubSettings.OAuth
    
    var isAuthenticated: Bool {
        get {
            return accessToken != nil
        }
    }
    
    /* ignore the warning, the _ is prepare for swift 3 */
    func fetchUserGithubProjects(_ requestFrom: UIViewController!, _ callback: (success: Bool, projects: [Project]?)->()) {
        let loginOperation = GithubLoginShowModalIfNeedOperation(sender: requestFrom)
        let fetchGithubProjects = GithubFetchUserGithubProjectsOperation { (success, projects) in
            callback(success: true, projects: projects)
        }

        fetchGithubProjects.addDependency(loginOperation)
        
        NSOperationQueue.init().addOperations([loginOperation, fetchGithubProjects], waitUntilFinished: false )
    }

    func didFinishGithubLogin(success success: Bool, code: String) {
        let accessTokenURL = NSURL(string: "https://github.com/login/oauth/access_token?"
                                          + "client_id=" + OAuthSettings.clientID + "&"
                                          + "client_secret=" + OAuthSettings.clientSecret + "&"
                                          + "code=" + code)!

        let accessTokenRequest = NSMutableURLRequest(URL: accessTokenURL)
        accessTokenRequest.HTTPMethod = "POST"

        NSURLSession.sharedSession().dataTaskWithRequest(accessTokenRequest) { (data, _, _) in
            if let data = data {
                let responseString = String(data: data, encoding: NSUTF8StringEncoding)!
                accessToken = responseString.urlAPIComponents?["access_token"] ?? ""
            }
        }.resume()
    }
}