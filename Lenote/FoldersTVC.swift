//
//  FoldersTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 22/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit
import LKAlertController
import SwiftDate

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
        tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height)
        
        searchBar.delegate = self
        
        folders = notesManager.fetchFolders() as! [Folder]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FolderCell") as! FolderCell
        let folder = folders[indexPath.row]
        
        cell.titleLabel.text = folder.title
        
        switch (folder.notes?.count)! {
        case 0:
            cell.detailsLabel.text = "No items"
        case 1:
            cell.detailsLabel.text = "1 item"
        default:
            cell.detailsLabel.text = String(format: "%i items", (folder.notes?.count)!)
        }
        
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
            folders.removeAtIndex(indexPath.row)
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
        searchBar.resignFirstResponder()
        
        switch searchBar.text! {
        case commands.deleteAllNotes.rawValue:
            notesManager.deleteAllNotes()
            
            folders = notesManager.fetchFolders() as! [Folder]
            
            tableView.reloadData()
        
        case commands.printAllNotes.rawValue:
            let notes = notesManager.fetchNotes()
            
            for note in notes! {
                print(String(format: "Title: %@, Folder: %@", (note as! Note).title!, ((note as! Note).folder! as Folder).title!))
            }
        
        case commands.deleteAllData.rawValue:
            notesManager.deleteAllData()
            
            folders = notesManager.fetchFolders() as! [Folder]
            
            tableView.reloadData()
        default:
            return
        }
    }
    
    //MARK: - Event Handlers
    @IBAction func pressNewFolder(sender: UIBarButtonItem) {
        var textField = UITextField()
        textField.placeholder = "Name"
        textField.font = textField.font?.fontWithSize(14)
        textField.returnKeyType = .Done
        
        Alert(title: "New Folder", message: "Enter a name for this folder.")
            .addAction("Cancel", style: .Cancel, handler: { _ in
                print(textField.isFirstResponder()) //FIXME: - Dismiss keyboard
            })
            .addAction("Save", style: .Default, handler: { _ in
                print(textField.isFirstResponder()) //FIXME: - Dismiss keyboard
                self.notesManager.createFolderWithName(textField.text)
                self.folders = self.notesManager.fetchFolders() as! [Folder]
                self.tableView.reloadData()
            }).addTextField(&textField).show()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Folder" {
            let destVC = segue.destinationViewController as! FolderTVC
            
            destVC.folder = folder
        }
    }
}

