//
//  HistoryTableViewCell.swift
//  CalARie
//
//  Created by Brendon Ho on 9/23/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import UIKit
import SwiftyJSON
class HistoryTableViewCell : UITableViewCell {
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var food : UILabel!
    @IBOutlet weak var calories : UILabel!
    let datNutritionData : JSON? = JSON.null
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
