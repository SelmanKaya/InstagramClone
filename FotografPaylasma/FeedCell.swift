//
//  FeedCell.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 28.12.2024.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var yorumText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
