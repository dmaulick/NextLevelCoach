//
//  CalendarTableViewCell.swift
//  ChatChat
//
//  Created by David Maulick on 11/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var whatToWearLabel: UILabel!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var event: Event?
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */

}
