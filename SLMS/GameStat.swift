//
//  GameStat.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import Foundation

class GameStat : NSObject
{
    
    // MARK: Properties
    var created: NSDate = NSDate()
    var updated: NSDate = NSDate()
    var objectId: NSString?
    var ownerId: NSString?
    
    var awayTeamScore: NSNumber?
    var homeTeamScore: NSNumber?
    
    var cards: NSMutableArray? = NSMutableArray()
    var goals: NSMutableArray? = NSMutableArray()
    
    //Cards
    func addToCards(card: Card)
    {
        if(self.cards == nil)
        {
            self.cards = NSMutableArray()
        }
        self.cards?.addObject(card)
    }
    
    func removeFromCards(card: Card)
    {
        self.cards?.removeObject(card)
        if(self.cards?.count <= 0){
            self.cards = nil
        }
    }
    
    func loadCards() -> NSMutableArray
    {
        if(self.cards != nil)
        {
            Backendless.sharedInstance().persistenceService.load(self, relations: ["cards"])
        }
        return self.cards!
    }
    
    func freeCards()
    {
        if(self.cards == nil){
            return
        }
        
        self.cards!.removeAllObjects()
        self.cards = nil
    }
    
    
    //Goals
    func addToGoals(goal: Goal)
    {
        if(self.goals == nil)
        {
            self.goals = NSMutableArray()
        }
        self.goals?.addObject(goal)
    }
    
    func removeFromGoals(goal: Goal)
    {
        self.goals?.removeObject(goal)
        if(self.goals?.count <= 0){
            self.goals = nil
        }
    }
    
    func loadGoals() -> NSMutableArray
    {
        if(self.goals != nil)
        {
            Backendless.sharedInstance().persistenceService.load(self, relations: ["goals"])
        }
        return self.goals!
    }
    
    func freeGoals()
    {
        if(self.goals == nil){
            return
        }
        
        self.goals!.removeAllObjects()
        self.goals = nil
    }
}