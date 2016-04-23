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
    optional func AllTeamsReceived(teams: [Team])//AllPlayersReceived
    optional func AllCoachesReceived(coaches: [Coach])
    optional func AllPlayersReceived(players: [Player])
    optional func AllRefsReceived(referees: [Referee])
    optional func AllOrganizerRecieved(organizers: [Organizers])
    optional func AllFieldsRecieved(fields: [Field])
    
    optional func foundCoachWithEamil(coach: Coach)
    
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
                
                if leagues != nil
                {
                    print("Successfully retrieved leagues " + String(leagues?.count))
                    for league in leagues! {
                        print("league = \(league.name)")
                    }
                    self.delegate?.AllLeaguesReceived!(leagues!)
                } else {
                    print("Leagues Retreived are nil, try again")
                }
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
    
    func removeLeagueSync(league: League)
    {
        let dataStore = backendless.data.of(League.ofClass())
        
        dataStore.remove(
            league,
            response: { (result: AnyObject!) -> Void in
                print("league has been deleted: \(result)")
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error (2): \(fault)")
        })
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
    
    func getAllTeamsAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Team.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                let teams = retrievedCollection.data as? [Team];
                
                if teams != nil
                {
                    print("Successfully retrieved teams " + String(teams?.count))
                    for team in teams! {
                        print("team = \(team.name)")
                    }
                    self.delegate?.AllTeamsReceived!(teams!)
                } else {
                    print("Teams Retreived are nil, try again")
                }
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
    
    
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
    

    
    //Player
    func getAllPlayersAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Player.ofClass()) as IDataStore
        dataStore.find(query,
                       response: { (retrievedCollection) -> Void in
                        let players = retrievedCollection.data as? [Player];
                        print("Successfully retrieved players " + String(players?.count))
                        for player in players! {
                            print("name = \(player.personalInfo?.fname)")
                        }
                        self.delegate?.AllPlayersReceived!(players!)
            })
        { (fault) -> Void in
            print("Server reported an error: \(fault)")
        }
    }
    
    func savePlayerAsync(player: Player)
    {
        var error: Fault?
        let result = backendless.data.save(player, error: &error) as? Player
        if error == nil {
            print("player has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    
    
    //Coach
    func getAllCoachesAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Coach.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                let coaches = retrievedCollection.data as? [Coach];
                print("Successfully retrieved coaches " + String(coaches?.count))
                for coach in coaches! {
                    print("Coach = \(coach.objectId)")
                }
                
                self.delegate?.AllCoachesReceived!(coaches!)
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
    
    
    func saveCoachAsync(coach: Coach)
    {
        var error: Fault?
        let result = backendless.data.save(coach, error: &error) as? Coach
        if error == nil {
            print("coach has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    func getCoachWithEmail(email: String)
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Coach.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                let coaches = retrievedCollection.data as? [Coach];
                print("Successfully retrieved coaches " + String(coaches?.count))
                for coach in coaches! {
                    print("Coach = \(coach.objectId)")
                    if coach.personalInfo?.email == email
                    {
                        print("found the coach with email " + email)
                        self.delegate?.foundCoachWithEamil!(coach)
                        break
                    }
                }
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
    
    //Referee
    func getAllRefsAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Referee.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                let referees = retrievedCollection.data as? [Referee];
                if referees != nil
                {
                    print("Successfully retrieved Refs " + String(referees?.count))
                    for referee in referees! {
                        print("Coach = \(referee.objectId)")
                    }
                    self.delegate?.AllRefsReceived!(referees!)
                } else{
                    print("referees Retreived are nil, try again")
                }
                
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
    
    func saveRefereeAsync(referee: Referee)
    {
        var error: Fault?
        let result = backendless.data.save(referee, error: &error) as? Referee
        if error == nil {
            print("Referee has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    

    
    //organizer
    func saveOrganizerAsync(organizer: Organizers)
    {
        var error: Fault?
        let result = backendless.data.save(organizer, error: &error) as? Organizers
        if error == nil {
            print("Organizer has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    
    func getAllOrganizersAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Organizers.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                
                let organizers = retrievedCollection.data as? [Organizers];
                
                if organizers != nil
                {
                    print("Successfully retrieved coaches " + String(organizers?.count))
                    for organizer in organizers! {
                        print("Coach = \(organizer.objectId)")
                    }
                    self.delegate?.AllOrganizerRecieved!(organizers!)
                } else {
                    print("Organizers Retreived are nil, try again")
                }
                
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
    
    //Fields
    
    func saveFieldAsync(field: Field)
    {
        var error: Fault?
        let result = backendless.data.save(field, error: &error) as? Field
        if error == nil {
            print("field has been saved: \(result)")
            self.delegate?.BackendlessDataDelegateDataIsSaved!(result)
        }
        else {
            print("fServer reported an error: \(error)")
            self.delegate?.BackendlessDataDelegateError!(error)
        }
    }
    
    func getAllFieldsAsync()
    {
        let query = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.pageSize = 100;
        query.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(Field.ofClass()) as IDataStore
        dataStore.find(query,
            response: { (retrievedCollection) -> Void in
                
                let fields = retrievedCollection.data as? [Field];
                
                if fields != nil
                {
                    print("Successfully retrieved fields " + String(fields?.count))
                    for field in fields! {
                        print("Coach = \(field.objectId)")
                    }
                    self.delegate?.AllFieldsRecieved!(fields!)
                } else {
                    print("fields Retreived are nil, try again")
                }
                
            })
            { (fault) -> Void in
                print("Server reported an error: \(fault)")
        }
    }
}