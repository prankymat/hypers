//
//  GithubLoginViewController.swift
//  hypers
//
//  Created by Matthew Wo on 6/11/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import UIKit

class GithubLoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let oauthEndpoint = NSURL(string: "https://github.com/login/oauth/authorize?client_id=" + GithubOAuthSettings.clientID + "&scope=repo")!
        let request = NSURLRequest(URL: oauthEndpoint)

        webview.delegate = self
        webview.loadRequest(request)
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where url.absoluteString.hasPrefix(GithubOAuthSettings.callbackURLPrefix) {
            // Got oauth code
            if let code = url.params[GithubOAuthSettings.codeKey] {
                GithubManager.sharedManager.didFinishGithubLogin(success: true, code: code)
                performSegueWithIdentifier("dismissGithubLoginVC", sender: nil)
                
            }
            return false
        }
        return true
    }
    
    

}