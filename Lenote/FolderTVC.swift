//
//  FolderTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 26/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class FolderTVC: UITableViewController, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let notesManager = NotesManager()
    
    var folder: Folder?
    var notes = [AnyObject]()
    var note: Note?
    
    var shouldBringUpKeyboard: Bool?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FolderTVC.didDismissNotesTypeTVC(_:)), name:"SelectedType", object: nil)
        
        title = folder?.title
        tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height)
        
        searchBar.delegate = self
        
        notes = (folder?.notes?.allObjects)!
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
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteCell
        
        cell.note = notes[indexPath.row] as? Note
        
        if notes[indexPath.row].title == "" {
            cell.titleLabel.text = "Untitled"
        } else {
            cell.titleLabel.text = notes[indexPath.row].title
        }
        
        if (notes[indexPath.row] as! Note).content == "" {
            cell.contentLabel.text = "No content"
        } else {
            cell.contentLabel.text = (notes[indexPath.row] as! Note).content
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NoteCell
        note = cell.note
        
        shouldBringUpKeyboard = false
        
        performSegueWithIdentifier("Note", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! NoteCell

            notesManager.deleteNote(cell.note)
            notes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    //MARK: - Event Handlers
    @IBAction func pressNewNote(sender: UIBarButtonItem) {
        performSegueWithIdentifier("NoteTypes", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Note" {
            let destVC = segue.destinationViewController as! NoteTVC
            
            destVC.shouldBringUpKeyboard = shouldBringUpKeyboard
            destVC.note = note
        } else if segue.identifier == "NoteTypes" {
            let destVC = segue.destinationViewController as! NoteTypesTVC
            
            destVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            destVC.popoverPresentationController!.delegate = self
        }
    }
    
    dynamic func didDismissNotesTypeTVC(notification: NSNotification) {
        let noteType: Int = notification.object as! Int
        
        switch noteType {
        case 0:
            shouldBringUpKeyboard = true
            
            note = notesManager.createEmptyNoteInFolder(folder)
            notes = notesManager.fetchNotesFromFolder(folder) as! [AnyObject]
            
            tableView.reloadData()
            
            performSegueWithIdentifier("Note", sender: self)
            self.resignFirstResponder()
        default:
            break
        }
    }
    
    //MARK: - Searchbar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
  
    //MARK: - Misc
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
