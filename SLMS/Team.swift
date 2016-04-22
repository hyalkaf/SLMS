//
//  Team.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import Foundation

class Team : NSObject
{
    
    // MARK: Properties
    var created: NSDate = NSDate()
    var updated: NSDate = NSDate()
    var objectId: NSString?
    var ownerId: NSString?
    
    var name: NSString?
    var players: NSMutableArray? = NSMutableArray()
    var captain: Player?
    var coach: Coach?
    var enrolledInLeague: Bool = false
    
    func addToPlayers(player: Player)
    {
        if(self.players == nil)
        {
            self.players = NSMutableArray()
        }
        self.players?.addObject(player)
    }
    
    func removeFromPlayers(player: Player)
    {
        self.players?.removeObject(player)
        if(self.players?.count <= 0){
            self.players = nil
        }
    }
    
    func loadPlayers() -> NSMutableArray
    {
        if(self.players != nil)
        {
            Backendless.sharedInstance().persistenceService.load(self, relations: ["players"])
        }
        return self.players!
    }
    
    func freePlayers()
    {
        if(self.players == nil){
            return
        }
        
        self.players!.removeAllObjects()
        self.players = nil
    }
}