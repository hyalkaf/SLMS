//
//  LeagueDetailTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class LeagueDetailTableViewController: UITableViewController, BackendlessDataDelegate {

    var backendless = Backendless.sharedInstance()
    var backendlessActions: BEActions = BEActions()
    
    var league: League = League()
    override func viewDidLoad() {
        super.viewDidLoad()
        backendlessActions.delegate = self
        //Laod all games for this league
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(self.league.objectId != nil){
            self.league = backendlessActions.getLeagueByIdSync(String(self.league.objectId!))!
            self.league.loadOrganizers()
            self.league.loadTeams()
            self.tableView.reloadData()
        }
     
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //print("section " + String(section))
        if(section == 0){
            return 1
        }
        
        if(section == 1){
            return (self.league.organizers?.count)!
        }
        if(section == 2){
            return (self.league.teams?.count)!
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        if(section == 0)
        {
            return "League Details"
        }
        
        if(section == 1)
        {
            return "League Organizers"
        }
        if(section == 2){
            return "League Teams"
        }
        
        if section == 3 
        {
            return "Team rankings"
        }
        
        return ""
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            return 200
        }else{
            return 70
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Calling tableVIew");
        var cell: UITableViewCell = UITableViewCell()
        
        if(indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("LeaugeDetailCell", forIndexPath: indexPath)
            if let leagueTableCell = cell as? LeagueDetalCellOnceSelected {
                leagueTableCell.leagueName.text = String(self.league.name!)
                leagueTableCell.numberOfTeams.text = String(self.league.numberOfTeams!)
                
                let formater = NSDateFormatter()
                formater.dateStyle = .MediumStyle
                formater.timeStyle = .ShortStyle
                
                leagueTableCell.startDate.text = String(formater.stringFromDate(self.league.startDate))
                
                leagueTableCell.endDate.text = String(formater.stringFromDate(self.league.finishDate))
            }
            
            return cell
        }
        
        //print("IndexPath row " + String(indexPath.row))
        
        if(indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("organizerCell", forIndexPath: indexPath)
            if let leagueTableCell = cell as? OrganizerNameTableViewCell {
                
                let organizers = (self.league.organizers?.objectAtIndex(indexPath.row) as! Organizers)
                
                leagueTableCell.organizerName.text = String(organizers.personalInfo!.fname)
            }
            return cell
        }
        
        
        if(indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("teamCell", forIndexPath: indexPath)
            let team = (self.league.teams?.objectAtIndex(indexPath.row) as! Team)
            
            if let leagueTableCell = cell as? TeamNameTableViewCell {
                
                leagueTableCell.teamName.text = String(team.name!)
            }
            return cell
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTeamDetails" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! TeamNameTableViewCell)?.row
            
            if let destination  = segue.destinationViewController as? TeamTableViewController {
                destination.team = (self.league.teams?.objectAtIndex(selectedIndex!) as! Team)
                print("This Team Name is[] " + String(destination.team.name))
            }
        }
        
        if segue.identifier == "showOrganizerDetails" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! OrganizerNameTableViewCell)?.row
            
            if let destination  = segue.destinationViewController as? OrganizerDetailsViewController {
                destination.organizer = (self.league.organizers?.objectAtIndex(selectedIndex!) as! Organizers)
            }
        }
        
        // Pass league to update view
        if segue.identifier == "UpdateLeague" {
            
            if let destination  = segue.destinationViewController as? UpdateLeagueUIViewController {
                destination.leagueToUpdate = self.league;
            }
        }
    }
}
