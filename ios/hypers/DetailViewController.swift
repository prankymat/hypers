//
//  DetailViewController.swift
//  hypers
//
//  Created by Matthew Wo on 6/12/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        self.navigationItem.leftItemsSupplementBackButton = true
    }
}
