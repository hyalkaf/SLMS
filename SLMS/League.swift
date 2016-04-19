//
//  League.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import Foundation


//
//  Discussion.swift
//  Briotie
//
//  Created by Nabil Ali Muthanna  on 2016-03-12.
//  Copyright © 2016 Briotie Inc. All rights reserved.
//

import Foundation

class League : NSObject
{

    // MARK: Properties
    var created: NSDate = NSDate()
    var updated: NSDate = NSDate()
    var objectId: NSString?
    var ownerId: NSString?
    
    var name: NSString?
    var numberOfTeams: NSNumber?
    var finishDate: NSDate = NSDate()
    var startDate: NSDate = NSDate()
    var teams: NSMutableArray? = NSMutableArray()
    var organizers: NSMutableArray? = NSMutableArray()
    var games: NSMutableArray? = NSMutableArray()

    
    func addToTeams(team: Team)
    {
        if(self.teams == nil)
        {
            self.teams = NSMutableArray()
        }
        self.teams?.addObject(team)
    }
    
    func removeFromTeams(team: Team)
    {
        self.teams?.removeObject(team)
        if(self.teams?.count <= 0){
            self.teams = nil
        }
    }
    
    func loadTeams() -> NSMutableArray
    {
        if(self.teams != nil)
        {
            Backendless.sharedInstance().persistenceService.load(self, relations: ["teams"])
        }
        return self.teams!
    }
    
    func freeTeams()
    {
        if(self.teams == nil){
            return
        }
        
        self.teams!.removeAllObjects()
        self.teams = nil
    }
    
    
    //Organizers
    func addToOrganizers(organizers: Organizers)
    {
        if(self.organizers == nil)
        {
            self.organizers = NSMutableArray()
        }
        self.organizers?.addObject(organizers)
    }
    
    func removeFromOrganizers(organizers: Organizers)
    {
        self.organizers?.removeObject(organizers)
        if(self.organizers?.count <= 0){
            self.organizers = nil
        }
    }
    
    func loadOrganizers() -> NSMutableArray
    {
        if(self.organizers != nil)
        {
            Backendless.sharedInstance().persistenceService.load(self, relations: ["organizers"])
        }
        return self.organizers!
    }
    
    func freeOrganizers()
    {
        if(self.organizers == nil){
            return
        }
        
        self.organizers!.removeAllObjects()
        self.organizers = nil
    }
    
    func addToGames(game: Game)
    {
        if(self.games == nil)
        {
            self.games = NSMutableArray()
        }
        self.games?.addObject(game)
    }
    
    func removeFromGames(game: Game)
    {
        self.games?.removeObject(game)
        if(self.games?.count <= 0){
            self.games = nil
        }
    }
    
    func loadGames() -> NSMutableArray
    {
        if(self.games != nil)
        {
            Backendless.sharedInstance().persistenceService.load(self, relations: ["games"])
        }
        return self.games!
    }
    
    func freeGames()
    {
        if(self.games == nil){
            return
        }
        
        self.games!.removeAllObjects()
        self.games = nil
    }
}


