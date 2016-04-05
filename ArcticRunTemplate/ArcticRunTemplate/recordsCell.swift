//
//  recordsCell.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-04-04.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class recordsCell: UITableViewCell {

    @IBOutlet weak var recordDate: UILabel!
    @IBOutlet weak var recordData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
