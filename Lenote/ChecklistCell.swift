//
//  ChecklistCell.swift
//  Lenote
//
//  Created by Wallace Toh on 28/5/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class ChecklistCell: UITableViewCell {
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var fullScreen: UIButton!
    
    @IBOutlet weak var titleTextfield: UITextField!
    
    var checklist: Checklist?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}