//
//  DetailViewController.swift
//  hypers
//
//  Created by Matthew Wo on 6/12/16.
//  Copyright © 2016 hypers. All rights reserved.
//

import UIKit

class CodeEditorViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    override func viewDidLayoutSubviews() {

    }
}
