//
//  EntryCell.swift
//  Lenote
//
//  Created by Wallace Toh on 27/5/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var contentTextview: UITextView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var delete: UIButton!
    
    var entry: Entry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}