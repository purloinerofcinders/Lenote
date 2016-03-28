//
//  NoteCell.swift
//  Lenote
//
//  Created by Wallace Toh on 26/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var compositionLabel: UILabel!
    
    var note: Note?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
