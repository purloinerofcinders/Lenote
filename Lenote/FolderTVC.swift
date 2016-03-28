//
//  FolderTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 26/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class FolderTVC: UITableViewController, UIPopoverPresentationControllerDelegate {
    let notesManager = NotesManager()
    
    var folder: Folder?
    var notes = [AnyObject]()
    var note: Note?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FolderTVC.didDismissNotesTypeTVC(_:)), name:"SelectedType", object: nil)
        
        title = folder?.title
        
        notes = (folder?.notes?.allObjects)!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
        
        if (notes[indexPath.row] as! Note).composition == "" {
            cell.compositionLabel.text = "No content"
        } else {
            cell.compositionLabel.text = (notes[indexPath.row] as! Note).composition
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NoteCell
        note = cell.note
        
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
            
            destVC.note = note
        } else if segue.identifier == "NoteTypes" {
            let destVC = segue.destinationViewController as! NoteTypesTVC
            
            destVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            destVC.popoverPresentationController!.delegate = self
        }
    }
    
    dynamic func didDismissNotesTypeTVC(notification: NSNotification) {
        if notification.object as! Int == 0 {
            note = notesManager.createEmptyNoteInFolder(folder)
            notes = notesManager.fetchNotesFromFolder(folder) as! [AnyObject]
            
            tableView.reloadData()
            
            performSegueWithIdentifier("Note", sender: self)
        }
    }
    
    //MARK: - Misc
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
