//
//  MenuVC.swift
//  Lenote
//
//  Created by Wallace Toh on 3/4/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        
        let searchField: UITextField = searchBar.valueForKey("_searchField") as! UITextField
        searchField.textColor = UIColor.whiteColor()
        
        searchBar.delegate = self
    }
    
    //MARK: - Tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }
    
    //MARK: - Event Handlers
    @IBAction func pressProfile(sender: AnyObject) {
    }
    
    @IBAction func pressSettings(sender: AnyObject) {
        appDelegate.centerViewController = appDelegate.settingsViewController()
    }
    
    //MARK: - Searchbar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
