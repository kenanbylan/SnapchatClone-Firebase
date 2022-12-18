//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Kenan Baylan on 18.12.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
