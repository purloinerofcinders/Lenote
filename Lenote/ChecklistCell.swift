//
//  ChecklistCell.swift
//  Lenote
//
//  Created by Wallace Toh on 28/5/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class ChecklistCell: UITableViewCell {
    var checklist: Checklist?
    
    @IBOutlet weak var delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}