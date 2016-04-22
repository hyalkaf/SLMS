//
//  GameCellUITableViewCell.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-22.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class GameCellUITableViewCell: UITableViewCell {

    
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var field: UILabel!
    @IBOutlet weak var referee: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
