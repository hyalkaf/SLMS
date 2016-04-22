//
//  AddTeamViewController.swift
//  SLMS
//
//  Created by Amjad Al-absi on 4/19/16.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class AddTeamTableViewController: UITableViewController,BackendlessDataDelegate {
    
    var beAction: BEActions = BEActions();
    var team: Team = Team();
    var PlayersList = [Player]()
    var selectedPlayers = [Player]()
    var checked = [Bool]()
    var captianChecked = [Bool]()
    var captainCheckedObjectId : NSString = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beAction.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        beAction.getAllPlayersAsync()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func AllPlayersReceived(players: [Player]) {
        let playerCount = players.count - 1;
        for i in 0...playerCount{
            if players[i].hasTeam == false {
                self.PlayersList.append(players[i])
                self.checked.append(false)
            }
        }
        
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        if(section == 0)
        {
            return "Team Name"
        }
        
        if(section == 1)
        {
            return "Choose Players"
        }
        if(section == 2){
            return "Choose Captain"
        }
   
        return ""
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return 1
        }
        
        if(section == 1){
            return self.PlayersList.count
        }
        
        if(section == 2){
            return self.selectedPlayers.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCellWithIdentifier("teamNameInputIdentifier", forIndexPath: indexPath)
            return cell
        }
        
        if indexPath.section == 1
        {
            cell = tableView.dequeueReusableCellWithIdentifier("choosePlayerForTeamIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = String(self.PlayersList[indexPath.row].personalInfo!.fname)
            
            if !self.checked[indexPath.row] {
                cell.accessoryType = .None
            } else if self.checked[indexPath.row]{
                cell.accessoryType = .Checkmark
            }
            
            return cell
        }
        
        if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCellWithIdentifier("choosePlayerForTeamIdentifier", forIndexPath: indexPath)
            cell.textLabel?.text = String(self.selectedPlayers[indexPath.row].personalInfo!.fname)
            
            if self.selectedPlayers[indexPath.row].objectId == self.captainCheckedObjectId
            {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            
            return cell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if indexPath.section == 1
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    self.checked[indexPath.row] = false
                    updateCaptainOptions(indexPath, add: false)
                    
                }else{
                    cell.accessoryType = .Checkmark
                    self.checked[indexPath.row] = true
                    updateCaptainOptions(indexPath, add: true)
                }
            }
            
            if indexPath.section == 2
            {
                if cell.accessoryType == .None
                {
                    self.captainCheckedObjectId = self.selectedPlayers[indexPath.row].objectId!
                }
            }
        }
        
        tableView.reloadData()
    }
    
    
    func updateCaptainOptions(indexPath: NSIndexPath, add: Bool)
    {
        if add
        {
            self.selectedPlayers.append(self.PlayersList[indexPath.row])
            self.captianChecked.append(false)
        }
        else
        {
            let itemToRemove = self.PlayersList[indexPath.row]
            let playerCout = self.selectedPlayers.count
            
            for i in 0...playerCout{
                if self.selectedPlayers[i].objectId == itemToRemove.objectId{
                    self.selectedPlayers.removeAtIndex(i)
                    self.captianChecked.removeAtIndex(i)
                    break
                }
            }
        }
    }
}