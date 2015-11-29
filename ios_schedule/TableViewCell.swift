//
//  TableViewCell.swift
//  ios_schedule
//
//  Created by Denis Turitsa on 2015-11-28.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var entryId:String = ""
    @IBOutlet weak var titlleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
