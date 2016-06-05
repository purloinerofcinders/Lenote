//
//  ChecklistVC.swift
//  Lenote
//
//  Created by Wallace Toh on 5/6/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class ChecklistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var notesManager = NotesManager()
    
    var checklist: Checklist?
    var items: [AnyObject]?
    
    //MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = checklist?.items?.allObjects
    }
    
    //MARK: - Tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")! as! ChecklistItemCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count)!
    }
    
    //MARK: - Button Events
    @IBAction func pressNew(sender: AnyObject) {
        notesManager.createItemInChecklist(checklist!)
        
        items = checklist?.items?.allObjects
        
        tableView.reloadData()
    }
}