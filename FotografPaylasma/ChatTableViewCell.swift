//
//  ChatTableViewCell.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 31.12.2024.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
