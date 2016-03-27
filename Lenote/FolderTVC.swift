//
//  FolderTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 26/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class FolderTVC: UITableViewController {
    let notesManager = NotesManager()
    
    var folder: Folder?
    var notes = [AnyObject]()
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = folder?.title
        
        notes = (folder?.notes?.allObjects)!
    }
    
    //MARK: - Tableview
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell") as! NoteCell
        cell.titleLabel.text = notes[indexPath.row].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    //MARK: - Event Handlers
    @IBAction func pressNewNote(sender: UIBarButtonItem) {
        notesManager.createNoteWithTitle("Hello World!", folder: folder)
        notes = notesManager.fetchNotesFromFolder(folder) as! [AnyObject]
        tableView.reloadData()
    }
}
