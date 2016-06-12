//
//  ViewController.swift
//  hypers
//
//  Created by Matthew Wo on 6/10/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController, ProjectsManagerDelegate {

    var projects = ProjectsManager.sharedManager.projects

    @IBAction func loginGithub(sender: AnyObject) {
        if GithubManager.sharedManager.isAuthenticated == false {
            performSegueWithIdentifier("showGithubLogin", sender: nil)
        }
    }

    @IBAction func cancelGithubLogin(segue:UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ProjectsManager.sharedManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        var cell: UITableViewCell
        if project.downloaded {
            cell = tableView.dequeueReusableCellWithIdentifier("DownloadedCell", forIndexPath: indexPath)
            cell.detailTextLabel?.text = project.filePath?.absoluteString
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("AvailableCell", forIndexPath: indexPath)
            cell.detailTextLabel?.text = "Tap to download"
        }
        cell.textLabel?.text = project.name
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGithubLogin" {
            let dstVC = segue.destinationViewController as! UINavigationController
            let loginVC = dstVC.viewControllers[0] as! GithubLoginViewController
            loginVC.delegate = GithubManager.sharedManager
        }
    }

    func didUpdateProjects() {
        projects = ProjectsManager.sharedManager.projects
        tableView.reloadData()
    }
}

