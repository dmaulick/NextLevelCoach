//
//  BackTableTeamCell.swift
//  ChatChat
//
//  Created by David Maulick on 11/29/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class BackTableTeamCell: UITableViewCell {
    @IBOutlet weak var TeamNameLabel: UILabel!
    
    @IBOutlet weak var teamImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
