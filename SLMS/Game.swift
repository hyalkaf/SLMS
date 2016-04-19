//
//  Game.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import Foundation

class Game : NSObject
{
    
    // MARK: Properties
    var created: NSDate = NSDate()
    var updated: NSDate = NSDate()
    var objectId: NSString?
    var ownerId: NSString?
    
    var gameDate: NSDate = NSDate()
    
    var homeTeam: Team?
    var awayTeam: Team?
    var field: Field?
    var gameStats: GameStat?
    var referee: Referee?
}