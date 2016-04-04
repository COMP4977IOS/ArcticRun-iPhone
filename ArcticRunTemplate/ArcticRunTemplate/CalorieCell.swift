//
//  CalorieCell.swift
//  ArcticRunTemplate
//
//  Created by Jox Toyod on 2016-04-03.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

class CalorieCell: UITableViewCell {
    
    @IBOutlet weak var calorieCell: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}