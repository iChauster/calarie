//
//  PopupViewCell.swift
//  CalARie
//
//  Created by Brendon Ho on 9/23/17.
//  Copyright © 2017 Brendon Ho. All rights reserved.
//

import UIKit

class PopupViewCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var val: UILabel!
    @IBOutlet weak var percentage : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func didMoveToSuperview() {
        self.layoutIfNeeded()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
