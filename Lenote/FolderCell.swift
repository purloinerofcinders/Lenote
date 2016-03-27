//
//  FolderCell.swift
//  Lenote
//
//  Created by Wallace Toh on 23/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import UIKit

class FolderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
