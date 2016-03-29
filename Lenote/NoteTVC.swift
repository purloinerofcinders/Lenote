//
//  NoteTVC.swift
//  Lenote
//
//  Created by Wallace Toh on 28/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class NoteTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    let notesManager = NotesManager()
    
    var note: Note?
    
    var shouldBringUpKeyboard: Bool?
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if shouldBringUpKeyboard == true {
            titleTextField.becomeFirstResponder()
        } 
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        titleTextField.text = note?.title
        contentTextView.text = note?.content
        
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        notesManager.saveNote(note, title: titleTextField.text!, content: contentTextView.text!)
    }
    
    //MARK: - Event Handlers
    @IBAction func pressDone(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == titleTextField {
            contentTextView.becomeFirstResponder()
            
            return false
        }
        return true
    }
}
