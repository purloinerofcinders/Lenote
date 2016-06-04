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
    
    var note: Note!
    
    var posts = [AnyObject]()
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        if tableView.tag == -1 {
            let post = posts[indexPath.row] as? Post

            switch (post?.type)! {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
                
                cell.entry = post?.entry
                cell.titleTextfield.text = cell.entry?.title
                cell.contentTextview.text = cell.entry?.content
                cell.infoLabel.text = dateManager.dateToString(post!.createdDate!, type: 1)
                
                cell.titleTextfield.addTarget(self, action: #selector(NoteVC.entryTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
                cell.titleTextfield.delegate = self
                cell.contentTextview.delegate = self
                cell.titleTextfield.tag = indexPath.row
                cell.contentTextview.tag = indexPath.row
                
                cell.delete.tag = 0
                cell.delete.addTarget(self, action: #selector(NoteVC.pressDelete(_:)), forControlEvents: .TouchUpInside)
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistCell") as! ChecklistCell
                
                cell.checklist = post?.checklist
                cell.tableView.delegate = self
                cell.tableView.dataSource = self
                cell.tableView.tag = indexPath.row //location of Checklist in main tableview
                cell.tableView.registerNib(UINib(nibName: "ChecklistItem", bundle: nil), forCellReuseIdentifier: "ChecklistItemCell")
                
                cell.delete.tag = 1
                cell.delete.addTarget(self, action: #selector(NoteVC.pressDelete(_:)), forControlEvents: .TouchUpInside)
                cell.newItem.addTarget(self, action: #selector(NoteVC.pressNewItem(_:)), forControlEvents: .TouchUpInside)
                
                return cell
                
            default:
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LEL")! //find a way to init an empty cell
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItemCell") as! ChecklistItemCell
            
            cell.titleTextfield.delegate = self
            cell.titleTextfield.tag = indexPath.row
            cell.titleTextfield.addTarget(self, action: #selector(NoteVC.itemTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
            
            let post = posts[tableView.tag]
            let checklist = post.checklist!
            let checklistItem = notesManager.fetchItemsInChecklist(checklist!)[indexPath.row]
            
            cell.titleTextfield.text = checklistItem.title
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == -1 {
            return posts.count
        } else {
            let post = posts[tableView.tag] as! Post
            let checklist = post.checklist!
            
            return (checklist.items?.count)!
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    //MARK: - Textfield
    func entryTextFieldDidChange(textField: UITextField) {
        let entry: Entry = (posts[textField.tag] as! Post).entry!
        entry.title = textField.text
    }
    
    func itemTextFieldDidChange(textField: UITextField) {
        let view = textField.superview?.superview?.superview?.superview?.superview //Bubbleview containing the textfield, ugly but gets the work done!! :D
        
        let point = view?.convertPoint(CGPointZero, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point!)
        
        let post = posts[indexPath!.row] as! Post
        let checklist = post.checklist
        let checklistItem = notesManager.fetchItemsInChecklist(checklist!)[textField.tag] as! ChecklistItem
        
        notesManager.updateItemTitle(checklistItem, title: textField.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let indexPath = NSIndexPath.init(forRow: textField.tag, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EntryCell
        
        cell.contentTextview.becomeFirstResponder()
        
        return false
    }
    
    //MARK: - Textview
    func textViewDidChange(textView: UITextView) {
        let entry: Entry = (posts[textView.tag] as! Post).entry!
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
        
        tableView.reloadData()
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
        
        tableView.reloadData()
    }
    
    func pressNewItem(sender: UIButton) {
        let point: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(point)!
        
        let post = posts[indexPath.row] as! Post
        let checklist = post.checklist
        
        notesManager.createItemInChecklist(checklist!)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChecklistCell
        
        cell.tableView.reloadData()
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
