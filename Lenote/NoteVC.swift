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
    
    @IBOutlet weak var dismissKeyboardButton: UIButton!
    
    @IBOutlet weak var dkbBtmConstraint: NSLayoutConstraint!
    
    let notesManager = NotesManager()
    let dateManager = DateManager()
    
    var note: Note!
    
    var posts = [AnyObject]()
    
    var checklistToPass: Checklist!
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "Entry", bundle: nil), forCellReuseIdentifier: "EntryCell")
        tableView.registerNib(UINib(nibName: "Checklist", bundle: nil), forCellReuseIdentifier: "ChecklistCell")
        
        posts = notesManager.fetchPostsSortedByCreatedDateFromNote(note!) as! [AnyObject]
        
        if posts.count == 0 {
            noticeLabel.hidden = false
        } else {
            noticeLabel.hidden = true
        }
        
        setUpDismissKeyboard()
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
        
        self.view.endEditing(true)
    }
    
    
    //MARK: - Tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row] as? Post

        switch (post?.type)! {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
            
            cell.entry = post?.entry
            cell.titleTextfield.text = cell.entry?.title
            cell.contentTextview.text = cell.entry?.content
            cell.infoLabel.text = dateManager.dateToString(post!.createdDate!, type: 1)
            
            cell.titleTextfield.addTarget(self, action: #selector(NoteVC.entryTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
            cell.titleTextfield.delegate = self
            cell.contentTextview.delegate = self
            cell.titleTextfield.tag = indexPath.row
            cell.contentTextview.tag = indexPath.row
            
            cell.delete.tag = 0
            cell.delete.addTarget(self, action: #selector(NoteVC.pressDelete(_:)), forControlEvents: .TouchUpInside)
            
            cell.selectionStyle = .None
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistCell") as! ChecklistCell
            
            cell.checklist = post?.checklist
            
            cell.delete.tag = 1
            cell.delete.addTarget(self, action: #selector(NoteVC.pressDelete(_:)), forControlEvents: .TouchUpInside)
            cell.fullScreen.addTarget(self, action: #selector(NoteVC.pressFullScreen(_:)), forControlEvents: .TouchUpInside)
            
            cell.titleTextfield.delegate = self
            cell.titleTextfield.addTarget(self, action: #selector(NoteVC.checklistTextfieldDidChange(_:)), forControlEvents: .EditingChanged)
            cell.titleTextfield.text = cell.checklist?.title
            
            cell.selectionStyle = .None
            
            return cell
            
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LEL")! //find a way to init an empty cell
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row] as! Post
        
        switch post.type as! Int {
        case 0:
            return 320
            
        case 1:
            return 183
            
        default:
            return 320
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    //MARK: - Textfield
    func entryTextFieldDidChange(textField: UITextField) {
        let entry: Entry = (posts[textField.tag] as! Post).entry!
        
        notesManager.updateEntryTitle(entry, title: textField.text!)
    }
    
    func checklistTextfieldDidChange(textField: UITextField) {
        let checklist: Checklist = (posts[textField.tag] as! Post).checklist!

        notesManager.updateChecklistTitle(checklist, title: textField.text!)
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
        
        notesManager.updateEntryContent(entry, content: textView.text)
    }
    
    //MARK: - Keyboard
    func keyboardWillAppear(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.dkbBtmConstraint.constant = keyboardFrame.size.height + 20
        
        UIView.animateWithDuration(0.5) {
            self.dismissKeyboardButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        UIView.animateWithDuration(0.5) {
            self.dismissKeyboardButton.alpha = 0
        }
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
    
    func pressDismissKeyboard(sender: AnyObject) {
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
    
    func pressFullScreen(sender: UIButton) {
        let point: CGPoint = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(point)!
        
        let post = posts[indexPath.row] as! Post
        checklistToPass = post.checklist
        
        performSegueWithIdentifier("Checklist", sender: self)
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Checklist" {
            let destVC = segue.destinationViewController as! ChecklistVC
            
            destVC.checklist = checklistToPass
        }
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
    
    func setUpDismissKeyboard() {
        dismissKeyboardButton.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        dismissKeyboardButton.layer.shadowColor = UIColor.init(white: 0, alpha: 1).CGColor
        dismissKeyboardButton.layer.shadowOpacity = 0.1;
        dismissKeyboardButton.layer.shadowRadius = 1.0;
        dismissKeyboardButton.layer.borderColor = UIColor.init(white: 0, alpha: 0.1).CGColor
        dismissKeyboardButton.layer.borderWidth = 0.5;
        dismissKeyboardButton.addTarget(self, action: #selector(NoteVC.pressDismissKeyboard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        dismissKeyboardButton.alpha = 0
    }
    
    //MARK: - Debugging
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            notesManager.fetchAllEntitiesCount()
        }
    }
}
