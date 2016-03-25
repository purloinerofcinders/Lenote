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
    
    let manager = NotesManager()
    var folders = [Folder]()

    // MARK: - View
     override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Folders"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        
        folders = manager.fetchFolders() as! [Folder]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for folder in folders {
            print(folder.title)
        }
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteCell
        let folder = folders[indexPath.row]
        
        cell.titleLabel.text = folder.title
        cell.detailsLabel.text = "No items"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let folder = folders[indexPath.row]
            
            manager.deleteFolder(folder)
            folders = manager.fetchFolders() as! [Folder]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }
    
    //MARK: - Actions
    @IBAction func pressNewFolder(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Confirm",
            style: UIAlertActionStyle.Default,
            handler: {(action:UIAlertAction) -> Void in
                let textField = alert.textFields![0] as UITextField
                self.manager.createFolderWithName(textField.text)
                self.folders = self.manager.fetchFolders() as! [Folder]
                self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler(textField)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - Event Handlers
    func textField(textField: UITextField!) {
        textField.placeholder = "Name"
    }
}

