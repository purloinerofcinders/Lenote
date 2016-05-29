//
//  NoteVC.swift
//  Lenote
//
//  Created by Wallace Toh on 28/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit
import LKAlertController
import SwiftDate

class NoteVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var dismissKeyboardButton: UIBarButtonItem!
    
    let notesManager = NotesManager()
    let dateManager = DateManager()
    
    var note: Note?
    
    var posts = [AnyObject]()
    var post: Post?
    
    var shouldBringUpKeyboard: Bool?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "Entry", bundle: nil), forCellReuseIdentifier: "EntryCell")
        tableView.registerNib(UINib(nibName: "Checklist", bundle: nil), forCellReuseIdentifier: "ChecklistCell")
        
        posts = notesManager.fetchPostsSortedByCreatedDateFromNote(note!) as! [AnyObject]
        
        dismissKeyboardButton.enabled = false
        
        if posts.count == 0 {
            noticeLabel.hidden = false
        } else {
            noticeLabel.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(NoteVC.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(NoteVC.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        notesManager.saveContext()
    }
    
    
    //MARK: - Tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        post = posts[indexPath.row] as? Post
        
        switch (post?.type)! {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
            
            cell.entry = post?.entry
            cell.titleTextfield.text = cell.entry?.title
            cell.contentTextview.text = cell.entry?.content
            cell.infoLabel.text = dateManager.dateToString(post!.createdDate!, type: 1)
            
            cell.titleTextfield.addTarget(self, action: #selector(NoteVC.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            cell.titleTextfield.delegate = self
            cell.contentTextview.delegate = self
            
            cell.delete.tag = 0
            cell.delete.addTarget(self, action: #selector(NoteVC.pressDelete(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistCell") as! ChecklistCell
            
            cell.checklist = post?.checklist
            
            cell.delete.tag = 1
            cell.delete.addTarget(self, action: #selector(NoteVC.pressDelete(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
            
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LEL")! //find a way to init an empty cell
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //MARK: - Textfield
    func textFieldDidChange(textField: UITextField) {
        let point: CGPoint = textField.convertPoint(CGPointZero, toView: tableView)
        let indexPath: NSIndexPath = tableView.indexPathForRowAtPoint(point)!
        
        let entry: Entry = (posts[indexPath.row] as! Post).entry!
        entry.title = textField.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let point: CGPoint = textField.convertPoint(CGPointZero, toView: tableView)
        let indexPath: NSIndexPath = tableView.indexPathForRowAtPoint(point)!
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EntryCell
        
        cell.contentTextview.becomeFirstResponder()
        
        return false
    }
    
    //MARK: - Textview
    func textViewDidChange(textView: UITextView) {
        let point: CGPoint = textView.convertPoint(CGPointZero, toView: tableView)
        let indexPath: NSIndexPath = tableView.indexPathForRowAtPoint(point)!
        
        let entry: Entry = (posts[indexPath.row] as! Post).entry!
        entry.content = textView.text
    }
    
    //MARK: - Keyboard
    func keyboardWillAppear(notification: NSNotification) {
        dismissKeyboardButton.enabled = true
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        dismissKeyboardButton.enabled = false
    }
    
    //MARK: - Button Events
    @IBAction func pressNew(sender: AnyObject) {
        ActionSheet(title: "New Post", message: "Select the type of post you would like to create.")
            .addAction("Cancel")
            .addAction("Entry", style: .Default, handler: { _ in
                self.createPostWithType(0)
            })
            .addAction("Checklist", style: .Default, handler: { _ in
                self.createPostWithType(1)
            })
            .addAction("Countdown", style: .Default, handler: { _ in
                
            }).show()
    }
    
    @IBAction func pressDismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func pressDelete(sender: UIButton) {
        ActionSheet(title: "Delete Post", message: "This action is irreversible. Are you sure you want to delete this post?")
            .addAction("Cancel")
            .addAction("Delete", style: .Destructive, handler: { _ in
                let point: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
                let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(point)!
                
                self.notesManager.deletePost(self.posts[indexPath.row] as! Post, type: sender.tag)
                
                self.posts = self.notesManager.fetchPostsSortedByCreatedDateFromNote(self.note!) as! [AnyObject]
                
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                
                if self.posts.count == 0 {
                    self.noticeLabel.hidden = false
                }
            }).show()
    }
    
    //MARK: - Custom
    func createPostWithType(type: NSInteger) {
        self.notesManager.createPostInNote(self.note!, type: type)
        self.posts = self.notesManager.fetchPostsSortedByCreatedDateFromNote(self.note!) as! [AnyObject]
        
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        
        if self.noticeLabel.hidden == false {
            self.noticeLabel.hidden = true
        }
    }
    
    //MARK: - Debugging
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            notesManager.fetchAllEntitiesCount()
        }
    }
}
