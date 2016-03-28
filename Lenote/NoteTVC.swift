//
//  NoteTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 28/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class NoteTVC: UITableViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var compositionTextView: UITextView!
    
    let notesManager = NotesManager()
    
    var note: Note?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = note?.title
        compositionTextView.text = note?.composition
        
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        notesManager.saveNote(note, title: titleTextField.text!, content: compositionTextView.text!)
    }
    
    //MARK: - Event Handlers
    @IBAction func pressDone(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
}
