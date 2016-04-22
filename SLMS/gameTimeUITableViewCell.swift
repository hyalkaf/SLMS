//
//  gameTimeUITableViewCell.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-21.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class gameTimeUITableViewCell: UITableViewCell {

    @IBOutlet weak var gameTime: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
