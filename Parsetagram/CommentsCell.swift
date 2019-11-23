//
//  CommentsCell.swift
//  Parsetagram
//
//  Created by Christian Alexander Valle Castro on 11/21/19.
//  Copyright © 2019 valle.co. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {
    
    //Mark :: properties
    
    @IBOutlet weak var nameLabel: UILabel!  // username of who commented
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
