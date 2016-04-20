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
        
        //print("section " + String(section))
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
        if(indexPath.section == 0)
        {
            return 70
        }else{
            return 70
        }
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
            
            if !self.captianChecked[indexPath.row] {
                cell.accessoryType = .None
            } else if self.captianChecked[indexPath.row]{
                cell.accessoryType = .Checkmark
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
            
            if indexPath.row == 2
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    //self.captianChecked[indexPath.row] = false
                }else{
                    resetCaptainChecks()
                    cell.accessoryType = .Checkmark
                    //self.captianChecked[indexPath.row] = true
                }
            }
        }
        tableView.reloadData()
    }
    
    func resetCaptainChecks()
    {
//        for i in 0...(self.captianChecked.count - 1){
//            self.captianChecked[i] = false
//        }
    }
    
    func updateCaptainOptions(indexPath: NSIndexPath, add: Bool)
    {
        if add {
            self.selectedPlayers.append(self.PlayersList[indexPath.row])
            self.captianChecked.append(false)
        } else {

            let itemToRemove = self.PlayersList[indexPath.row]
            let playerCout = self.selectedPlayers.count - 1
            
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