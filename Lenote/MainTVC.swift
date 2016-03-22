//
//  MainTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 22/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {
    
    var cellCount = 1
    

    // MARK: - View
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Navigation Bar
        
        self.title = "Notes"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Tableview
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteCell
        
        cell.titleLabel.text = "Hello World!"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    //MARK: - Actions
    
    @IBAction func pressAdd(sender: UIBarButtonItem) {
        cellCount += 1
        self.tableView.reloadData()
    }

}

