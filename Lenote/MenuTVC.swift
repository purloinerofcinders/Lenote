//
//  MenuTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 1/4/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewController {
    var selectedCellTag: Int?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCellTag = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("hey")
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
        if selectedCellTag == cell.tag {
            cell.contentView.alpha = 1
        } else {
            cell.contentView.alpha = 0.5
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        selectedCellTag = cell?.tag
        
        tableView.reloadData()
        
        switch (cell?.tag)! {
        case 0:
            appDelegate.centerViewController = appDelegate.foldersViewController()
        case 1:
            break
            
        case 2:
            appDelegate.centerViewController = appDelegate.settingsViewController()
            
        default:
            break
        }
    }
}
