//
//  NoteTypesTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 29/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class NoteTypesTVC: UITableViewController {
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        dismissViewControllerAnimated(false, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("SelectedType", object: indexPath.row)
        })
    }
}
