//
//  FoldersTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 22/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class FoldersTVC: UITableViewController, UISearchBarDelegate {
    enum commands: String {
        case deleteAllNotes = "deletenotes"
        case printAllNotes = "printnotes"
        case deleteAllData = "deleteall"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let notesManager = NotesManager()
    
    var folders = [Folder]()
    var folder: Folder?

    // MARK: - View
     override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Folders"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        
        searchBar.delegate = self
        
        folders = notesManager.fetchFolders() as! [Folder]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FolderCell") as! FolderCell
        let folder = folders[indexPath.row]
        
        cell.titleLabel.text = folder.title
        cell.detailsLabel.text = "No items"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        folder = folders[indexPath.row]
        
        performSegueWithIdentifier("Folder", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let folder = folders[indexPath.row]
            
            notesManager.deleteFolder(folder)
            folders = notesManager.fetchFolders() as! [Folder]
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
    
    //MARK: - Searchbar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        switch searchBar.text! {
            case commands.deleteAllNotes.rawValue:
                let notes = notesManager.fetchNotes()
                
                for note in notes! {
                    print((note as! Note).title)
                }
            
            case commands.printAllNotes.rawValue:
                let notes = notesManager.fetchNotes()
                
                for note in notes! {
                    print((note as! Note).title)
                    print(((note as! Note).folder as! Folder).title)
                }
            
            case commands.deleteAllData.rawValue:
                notesManager.deleteAllData()
            
            default:
                return
        }
    }
    
    //MARK: - Event Handlers
    @IBAction func pressNewFolder(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Confirm",
            style: UIAlertActionStyle.Default,
            handler: {(action:UIAlertAction) -> Void in
                let textField = alert.textFields![0] as UITextField
                self.notesManager.createFolderWithName(textField.text)
                self.folders = self.notesManager.fetchFolders() as! [Folder]
                self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler(textField)
        presentViewController(alert, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Folder" {
            let destVC = segue.destinationViewController as! FolderTVC
            
            destVC.folder = folder
        }
    }
    
    //MARK: - Misc
    
    func textField(textField: UITextField!) {
        textField.placeholder = "Name"
    }
}
