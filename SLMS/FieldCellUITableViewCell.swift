//
//  FieldCellUITableViewCell.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-21.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class FieldCellUITableViewCell: UITableViewCell {
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var fieldNumber: UILabel!
    @IBOutlet weak var fieldAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
