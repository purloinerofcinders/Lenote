//
//  MainTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 22/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cellCount = 1
    let manager = NotesManager()

    // MARK: - View
     override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        tableView.setContentOffset(CGPointMake(0, searchBar.frame.size.height), animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        manager.printSomething()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteCell
        
        cell.titleLabel.text = "Hello World!"
        cell.titleLabel.textColor = UIColor.darkGrayColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }
    
    //MARK: - Actions
    @IBAction func pressAdd(sender: UIBarButtonItem) {
        performSegueWithIdentifier("Note", sender: self)
    }

}

