//
//  Discussion.swift
//  Briotie
//
//  Created by Nabil Ali Muthanna  on 2016-03-12.
//  Copyright © 2016 Briotie Inc. All rights reserved.
//

import Foundation
//import Discussion

@objc protocol BackendlessDataDelegate {
    
    /*
        Gets called if the object was saved to backendless
        parameter : result - The object that was saved
    */
    optional func BackendlessDataDelegateDataIsSaved(result: AnyObject!)
    
    /*
        Gets called if the object wasn't saved to backendless
        parameter : fault - error returned from backendless which includes error code
                    and error message
    */
    optional func BackendlessDataDelegateError(fault: Fault!)
    
    optional func AllLeaguesReceivedForUser(leagues: [League])
    optional func AllLeaguesReceived(leagues: [League])
    
}


class BEActions {
    
    // MARK: Properties
    var backendless = Backendless.sharedInstance()
    var delegate: BackendlessDataDelegate? = nil


    // MARK: League - Read
    
    func getLeagueByIdSync(Id: String) ->League?
    {
        let dataStore = backendless.data.of(League.ofClass())
        var error: Fault?
        
        let foundLeagues = dataStore.findID(Id, fault: &error) as? League
        
        if error == nil {
            return foundLeagues
        } else{
            return nil;
        }
    }
    
  
    
    func getAllLeaguesAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(League.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                let leagues = retrievedCollection.data as? [League];
                print("Successfully retrieved leagues " + String(leagues?.count))
                for league in leagues! {
                    print("league = \(league.name)")
                }
                self.delegate?.AllLeaguesReceived!(leagues!)
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
    
    func saveLeagueSync(league: League)
    {
        var error: Fault?
        let result = backendless.data.save(league, error: &error) as? League
        if error == nil {
            print("League has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    
    // MARK: Game - Read

    func getGameByIdSync(Id: String) ->Game?
    {
        let dataStore = backendless.data.of(Game.ofClass())
        var error: Fault?
        
        let foundGame = dataStore.findID(Id, fault: &error) as? Game
        
        if error == nil {
            return foundGame
        } else{
            return nil;
        }
    }
    
    func saveGameSync(game: Game)
    {
        var error: Fault?
        let result = backendless.data.save(game, error: &error) as? Game
        if error == nil {
            print("Game has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    
    
    // MARK: Team - Read
    func getTeamByIdSync(Id: String) ->Team?
    {
        let dataStore = backendless.data.of(Team.ofClass())
        var error: Fault?
        
        let foundTeam = dataStore.findID(Id, fault: &error) as? Team
        
        if error == nil {
            return foundTeam
        } else{
            return nil;
        }
    }
    
    func saveTeamSync(team: Team)
    {
        var error: Fault?
        let result = backendless.data.save(team, error: &error) as? Team
        if error == nil {
            print("Team has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    
    // MARK: Person - Read
    
    func getPersonByIdSync(Id: String) ->Person?
    {
        let dataStore = backendless.data.of(Person.ofClass())
        var error: Fault?
        
        let foundPerson = dataStore.findID(Id, fault: &error) as? Person
        
        if error == nil {
            return foundPerson
        } else{
            return nil;
        }
    }
    
    
    func savePersonSync(person: Person)
    {
        var error: Fault?
        let result = backendless.data.save(person, error: &error) as? Person
        if error == nil {
            print("person has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
}