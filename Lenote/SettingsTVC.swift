//
//  SettingsTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 1/4/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
    }
    
    //MARK: - Event Handlers
    @IBAction func pressMenu(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.toggleLeftDrawer(sender, animated: false)
    }
}
