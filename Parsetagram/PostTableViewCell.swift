//
//  PostTableViewCell.swift
//  Parsetagram
//
//  Created by Christian Alexander Valle Castro on 11/16/19.
//  Copyright © 2019 valle.co. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    //Mark :: Properties
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
