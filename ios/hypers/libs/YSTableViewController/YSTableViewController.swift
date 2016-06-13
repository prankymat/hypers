//
//  YSTableViewController.swift
//  YSTableViewController
//
//  Created by 悠二 on 1/13/16.
//  Copyright © 2016 Yuji. All rights reserved.
//

import UIKit

class YSTableViewController: UITableViewController {
    
    var delegate: YSTableViewControllerDelegate?
    var hightlightedRows = [NSIndexPath]()
    var currentPath: NSIndexPath?
    var allowCrossSectionHighlighting: Bool = true
    var allowHightlightingRowsAcrossSection: Bool = true
    var usrLongPressing: Bool = false
    var longPressGesture: UILongPressGestureRecognizer! {
        didSet {
            longPressGesture.numberOfTouchesRequired = 1
            longPressGesture.minimumPressDuration = 0.7
        }
    }
    
    //MARK:- ViewControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardCommands()
        self.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(YSTableViewController.longPressRecognized(_:)))
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unhightlightCells()
    }
    
    func longPressRecognized(gesture: UILongPressGestureRecognizer) {
        
        if !usrLongPressing {
            
            let gesturePoint = gesture.locationInView(self.tableView)
            let correspondingIndexPath = self.tableView.indexPathForRowAtPoint(gesturePoint)
            guard let indexPath = correspondingIndexPath else {return}
            self.delegate?.tableViewController?(self, didLongPressCellAtIndexPath: indexPath)
            
        }
        switch gesture.state {
        case .Cancelled: fallthrough
        case .Ended: fallthrough
        case .Failed: usrLongPressing = false; return
        default: usrLongPressing = true
        }
    }
    
    //MARK:- KeyboardCommands
    private func addKeyboardCommands() {
        let globalAction: Selector = #selector(YSTableViewController.keyPressed(_:))
        let supportedMoifierFlagsCombinations:[UIKeyModifierFlags] = [[UIKeyModifierFlags.Command], [UIKeyModifierFlags.Shift], [UIKeyModifierFlags.init(rawValue: 0)]]
        let upArrowCmds = newKeyCommands(UIKeyInputUpArrow, forModifierFlagsCombinations: supportedMoifierFlagsCombinations, actionSelector: globalAction)
        let dnArrowCmds = newKeyCommands(UIKeyInputDownArrow, forModifierFlagsCombinations: supportedMoifierFlagsCombinations, actionSelector: globalAction)
        let returnCmd = UIKeyCommand(input: "\r", modifierFlags: UIKeyModifierFlags(rawValue: 0), action: globalAction)
        
        self.addKeyCommands(upArrowCmds)
        self.addKeyCommands(dnArrowCmds)
        self.addKeyCommand(returnCmd)
    }
    
    private func newKeyCommands(input: String, forModifierFlagsCombinations c: [UIKeyModifierFlags], actionSelector selector: Selector) -> [UIKeyCommand] {
        var cmds = [UIKeyCommand]()
        for c_ in c {
            let cmd = UIKeyCommand(input: input, modifierFlags: c_, action: selector)
            cmds.append(cmd)
        }
        return cmds
    }
    
    //MARK: Key pressed handlers
    func keyPressed(keyCmd: UIKeyCommand) {
        if keyCmd.modifierFlags.rawValue == 0 {
            singleKeyPressed(keyCmd.input)
        }
        if keyCmd.modifierFlags == UIKeyModifierFlags.Shift {
            keyPressedWithShfitKey(keyCmd.input)
        }
    }
    
    private func singleKeyPressed(input: String) {
        if hightlightedRows.count == 0 {
            hightlightTopVisibleCell()
            return
        }
        switch input {
        case UIKeyInputUpArrow: hightlightCellAtIndexPath(tableView.perviousIndexPath(currentPath: currentPath ?? hightlightedRows[0], allowCrossSection: allowCrossSectionHighlighting), atScrollPosition: .Top)
        case UIKeyInputDownArrow: hightlightCellAtIndexPath(tableView.nextIndexPath(currentPath: currentPath ?? hightlightedRows[0], allowCrossSection: allowCrossSectionHighlighting), atScrollPosition: .Bottom)
        case "\r": self.returnKeyDidPressed()
        default: break
        }
    }
    
    private func keyPressedWithShfitKey(input: String) {
        if hightlightedRows.count == 0 {return}
        switch input {
        case UIKeyInputUpArrow: appendPreviousIndexPathToSelection()
        case UIKeyInputDownArrow: appendNextIndexPathToSelection()
        case "\r": self.returnKeyDidPressedWithShiftKey()
        default: break
        }
    }
    
    private func returnKeyDidPressed() {
        if self.hightlightedRows.count == 1 {
            tableView(self.tableView, didSelectRowAtIndexPath: self.hightlightedRows[0])
        } else if self.hightlightedRows.count > 1 {
            self.delegate?.tableViewController?(self, didSelectRowsAtIndexPaths: self.hightlightedRows)
        }
    }
    
    private func returnKeyDidPressedWithShiftKey() {
        if self.hightlightedRows.count > 1 {
            
        }
    }
    
    //MARK:- Highlighting/Unhighlighting Rows
    
    private func hightlightCellAtIndexPath(indexPath: NSIndexPath?, atScrollPosition position: UITableViewScrollPosition? = nil) {
        if let indexPath = indexPath {
            unhightlightCells()
            self.hightlightCellAtIndexPath(indexPath, atScrollPosition: position)
        }
    }
    
    private func hightlightCellAtIndexPath(indexPath: NSIndexPath, atScrollPosition position: UITableViewScrollPosition? = nil) {
        if !tableView.indexPathsForVisibleRows!.contains(indexPath) || (indexPath.row == 0 && indexPath.section == 0) || (indexPath.section == tableView.numberOfSections - 1 && indexPath.row == tableView.numberOfRowsInSection(tableView.numberOfSections - 1)) {
            if let position = position {
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: position, animated: false)
            }
        }
        
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
            self.delegate?.tableViewController?(self, willHighlightRowsAtIndexPaths: [indexPath])
            cell.highlighted = true
            self.hightlightedRows.append(indexPath)
            self.currentPath = indexPath
            self.delegate?.tableViewController?(self, didHighlightRowsAtIndexPaths: [indexPath])
        }
    }
    
    private func hightlightTopVisibleCell() -> NSIndexPath? {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            if indexPaths.count > 0 {
                let indexPath = indexPaths[0]
                hightlightCellAtIndexPath(indexPath)
                return indexPath
            }
        }
        return nil
    }
    
    private func unhightlightCell(atIndexPath indexPath: NSIndexPath) {
        for (index, row) in self.hightlightedRows.enumerate() {
            if row == indexPath {
                self.hightlightedRows.removeAtIndex(index)
                self.tableView.cellForRowAtIndexPath(row)?.highlighted = false
            }
        }
        self.delegate?.tableViewController?(self, didUnhighlightRowAtIndexPaths: [indexPath])
    }
    
    private func unhightlightCells() {
        for row in self.hightlightedRows {
            self.tableView.cellForRowAtIndexPath(row)?.highlighted = false
        }
        if let row = self.tableView.indexPathForSelectedRow {
            self.tableView.cellForRowAtIndexPath(row)?.selected = false
        }
        let indexPaths = self.hightlightedRows
        self.hightlightedRows.removeAll()
        self.delegate?.tableViewController?(self, didUnhighlightRowAtIndexPaths: indexPaths)
        self.currentPath = nil
    }
    
    //MARK: Group Highlighting
    
    private func appendPreviousIndexPathToSelection() {
        if self.delegate?.tableViewControllerShouldAllowMultiSelection?(self) ?? true {
            appendCloestRowToHightlightedRows(isDescending: true)
        }
    }
    
    private func appendNextIndexPathToSelection() {
        if self.delegate?.tableViewControllerShouldAllowMultiSelection?(self) ?? true {
            appendCloestRowToHightlightedRows(isDescending: false)
        }
    }
    
    private func appendCloestRowToHightlightedRows(isDescending descending: Bool) {
        guard let currentPath = currentPath else {return}
        let path = descending ? tableView.perviousIndexPath(currentPath: currentPath) : tableView.nextIndexPath(currentPath: currentPath)
        if let path = path {
            if self.hightlightedRows.contains(path) {
                self.unhightlightCell(atIndexPath: currentPath)
            } else {
                tableView.scrollToRowAtIndexPathIfNotVisible(path, atScrollPosition: descending ? .Top : .Bottom)
                self.hightlightCellAtIndexPath(path)
            }
            self.currentPath = path
        } else {
            if hightlightedRows.count > 1 {
                self.currentPath = hightlightedRows[0]
                appendCloestRowToHightlightedRows(isDescending: descending)
            }
        }
    }
    
    //MARK:- TableViewDelegate
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let lhs = hightlightedRows.contains(indexPath)
        let rhs = hightlightedRows.count <= 1
        if xor(lhs, rhs: rhs) || (rhs == false && lhs == false) {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if hightlightedRows.contains(indexPath) {hightlightCellAtIndexPath(indexPath)}
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.highlighted = hightlightedRows.contains(indexPath)
        self.delegate?.tableViewController?(self, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if usrLongPressing {return}
        
        if self.hightlightedRows.count > 0 {
            self.unhightlightCells()
            self.hightlightCellAtIndexPath(indexPath)
        }
        
        if !self.hightlightedRows.contains(indexPath) {
            self.hightlightedRows.append(indexPath)
            self.currentPath = indexPath
        }
        self.delegate?.tableViewController?(self, didSelectRowAtIndexPath: indexPath)
    }
    
    //MARK:- UIResponser
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
}

//MARK:- Extensions
private extension UIViewController {
    func addKeyCommands(commnds: [UIKeyCommand]) {
        for command in commnds {self.addKeyCommand(command)}
    }
}

func xor(lhs: Bool, rhs: Bool) -> Bool {
    let l: Int = lhs ? 1 : 0
    let r: Int = rhs ? 1 : 0
    return (l ^ r == 1) ? true : false
}

extension NSIndexPath {
    func isGreaterThan(indexPath: NSIndexPath) -> Bool {
        if indexPath.section > self.section {return false}
        if indexPath.section < self.section {return true}
        if indexPath.row >= self.row {return false} else {return true}
    }
}

extension UITableView
{
    func scrollToRowAtIndexPathIfNotVisible(indexPath: NSIndexPath, atScrollPosition position: UITableViewScrollPosition) {
        if !self.indexPathsForVisibleRows!.contains(indexPath) {
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition: position, animated: false)
        }
    }
    
    func perviousIndexPath(currentPath path: NSIndexPath, allowCrossSection allowedCS: Bool = true) -> NSIndexPath? {
        if path.row > 0 {
            return NSIndexPath(forRow: path.row - 1, inSection: path.section)
        } else {
            if path.section > 0 && allowedCS {
                let rows = self.numberOfRowsInSection(path.section - 1)
                if rows != 0 {
                    return NSIndexPath(forRow: rows - 1, inSection: path.section-1)
                } else {
                    return perviousIndexPath(currentPath: NSIndexPath(forRow: 0, inSection: path.section - 1))
                }
            }
        }
        return nil
    }
    
    func nextIndexPath(currentPath path: NSIndexPath, allowCrossSection allowedCS: Bool = true) -> NSIndexPath? {
        
        if path.section <= numberOfSections - 1 {
            if path.row < numberOfRowsInSection(path.section) - 1 { //next row exists
                
                return NSIndexPath(forRow: path.row + 1, inSection: path.section)
            }
            
            if path.section < numberOfSections - 2  && allowedCS { //Not the last section
                
                if numberOfRowsInSection(path.section + 1) != 0 {
                    
                    return NSIndexPath(forRow: 0, inSection: path.section + 1)
                } else {
                    
                    return nextIndexPath(currentPath: NSIndexPath(forRow: 0, inSection: path.section + 1))
                }
            }
        }
        return nil
    }
    
}