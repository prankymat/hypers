//
//  YSTableViewControllerDelegate.swift
//  YSTableViewController
//
//  Created by Yuji on 1/19/16.
//  Copyright © 2016 Yuji. All rights reserved.
//

import UIKit

@objc protocol YSTableViewControllerDelegate {
    
    optional func tableViewControllerShouldAllowMultiSelection(tableViewController: YSTableViewController) -> Bool
    
    optional func tableViewController(tableViewController: YSTableViewController, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    
    optional func tableViewController(tableViewController: YSTableViewController, didUnhighlightRowAtIndexPaths indexPaths: [NSIndexPath])
    
    optional func tableViewController(tableViewController: YSTableViewController, willHighlightRowsAtIndexPaths indexPaths: [NSIndexPath])
    optional func tableViewController(tableViewController: YSTableViewController, didHighlightRowsAtIndexPaths indexPath: [NSIndexPath])
    
    optional func tableViewController(tableViewController: YSTableViewController, willSelectRowAtIndexPath indexPath: NSIndexPath)
    optional func tableViewController(tableViewController: YSTableViewController, didSelectRowAtIndexPath indexPath: NSIndexPath)
    
    optional func tableViewController(tableViewController: YSTableViewController, didSelectRowsAtIndexPaths indexPaths: [NSIndexPath])
    optional func tableViewController(tableViewController: YSTableViewController, didLongPressCellAtIndexPath indexPath: NSIndexPath)
    
}