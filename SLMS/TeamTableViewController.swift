//
//  TeamTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class TeamTableViewController: UITableViewController {

    var backendless = Backendless.sharedInstance()

    var team: Team = Team()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        self.team.loadPlayers()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Team Coach"
        }
        if section == 1
        {
            return "Team Captain"
        }
        if section == 2
        {
            return "Team Players"
        }
        
        if section == 0{
            return "Team Stats"
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            if(self.team.coach != nil){
                return 1
            } else{
                return 0
            }
        }
        
        if(section == 1){
            if(self.team.captain != nil)
            {
                return 1
            }else{
                return 0
            }
        }
        
        if(section == 2){
            if(self.team.players != nil){
                return (self.team.players?.count)!
            } else{
                return 0
            }
        }
        
        return 0
    }

    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if(indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("coachNameCell", forIndexPath: indexPath)
            if let leagueTableCell = cell as? CoachNameTableViewCell {
                let coach = self.team.coach!.personalInfo!
                leagueTableCell.coachName.text = String(coach.fname)
            }
            
            return cell
        }
        
        if(indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("captainNameCell", forIndexPath: indexPath)
            if let leagueTableCell = cell as? CaptainNameTableViewCell {
                let captain = self.team.captain!.personalInfo!
                leagueTableCell.captianName.text = String(captain.fname)
            }
            
            return cell
        }
        
        if(indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("playerNameCell", forIndexPath: indexPath)
            if let leagueTableCell = cell as? PlayerNameTableViewCell {
                let player = (self.team.players?.objectAtIndex(indexPath.row) as! Player)
                leagueTableCell.playerName.text = String(player.personalInfo!.fname)
            }
            
            return cell
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTeamPlayerDetails" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! PlayerNameTableViewCell)?.row
            
            
            print(String(selectedIndex));
            if let destination  = segue.destinationViewController as? PlayerDetailsViewController {
                destination.player = (self.team.players?.objectAtIndex(selectedIndex!) as! Player)
                destination.IS_CAPTAIN = false;
            }
        }
        
        
        if segue.identifier == "showTeamCaptainDetails" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! CaptainNameTableViewCell)?.row
            
            
            print(String(selectedIndex));
            if let destination  = segue.destinationViewController as? PlayerDetailsViewController {
                destination.player = (self.team.players?.objectAtIndex(selectedIndex!) as! Player)
                destination.IS_CAPTAIN = true;
            }
        }
        
        //showTeamCoachDetails
        if segue.identifier == "showTeamCoachDetails" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! CoachNameTableViewCell)?.row
            
            
            print(String(selectedIndex));
            if let destination  = segue.destinationViewController as? CoachDetailsViewController {
                destination.coach = (self.team.coach)!
            }
        }
    }
}
