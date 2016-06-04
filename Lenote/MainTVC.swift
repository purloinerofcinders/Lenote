//
//  MainTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 26/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit
import LKAlertController

class MainTVC: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let notesManager = NotesManager()
    
    var notes = [AnyObject]()
    var note: Note?
    
    var shouldBringUpKeyboard: Bool?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
        tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height)
        
        searchBar.delegate = self
        
        notes = notesManager.fetchNotes() as! [AnyObject]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    //MARK: - Options
    override func canBecomeFirstResponder() -> Bool {
        return true
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
        
        let count = (notes[indexPath.row] as! Note).posts?.count
        
        if count == 0 {
            cell.contentLabel.text = "No posts"
        } else {
            cell.contentLabel.text = String(format: "%i posts", count!)
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
    
    //MARK: - Button Events
    @IBAction func pressNewNote(sender: UIBarButtonItem) {
        var textField = UITextField()
        textField.placeholder = "Name"
        textField.font = textField.font?.fontWithSize(14)
        textField.returnKeyType = .Done
        
        Alert(title: "New Note", message: "Enter a name for this note.")
            .addAction("Cancel")
            .addAction("Save", style: .Default, handler: { _ in
                self.note = self.notesManager.createNoteWithTitle(textField.text!)
                self.shouldBringUpKeyboard = true
                
                self.notes = self.notesManager.fetchNotes() as! [AnyObject]
                
                self.resignFirstResponder()
                self.tableView.reloadData()
                
                self.performSegueWithIdentifier("Note", sender: self)
            }).addTextField(&textField).show()
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Note" {
            let destVC = segue.destinationViewController as! NoteVC
            
            destVC.shouldBringUpKeyboard = shouldBringUpKeyboard
            destVC.note = note
        }
    }
    
    //MARK: - Searchbar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
