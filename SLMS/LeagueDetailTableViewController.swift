//
//  LeagueDetailTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class LeagueDetailTableViewController: UITableViewController, BackendlessDataDelegate {

    @IBOutlet weak var editLeagueBtn: UIBarButtonItem!
    
    var backendless = Backendless.sharedInstance()
    var backendlessActions: BEActions = BEActions()
    var isReferee = false
    
    var league: League = League()
    override func viewDidLoad() {
        super.viewDidLoad()
        backendlessActions.delegate = self
        
        self.tableView.separatorStyle = .None
        
        let currentUser = backendless.userService.currentUser
        self.isReferee = false

        if currentUser != nil{
            let role = currentUser.getProperty("role") as! String
            if role != "Organizer"
            {
                self.editLeagueBtn.title = ""
                self.editLeagueBtn.style = UIBarButtonItemStyle.Plain
                self.editLeagueBtn.enabled = false
            }
            
            if role == "Referee"
            {
                self.isReferee = true
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.league.objectId != nil){
            let temLeague = backendlessActions.getLeagueByIdASync(String(self.league.objectId!))
            if temLeague != nil
            {
                self.league = temLeague!
                self.league.loadOrganizers()
                self.league.loadTeams()
                self.tableView.reloadData()
            }
        }
    }

    func LeagueReceived(league: League) {
        self.league = league
        self.tableView.reloadData()
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(section == 0){
            return 1
        }
        
        if(section == 1){
            return (self.league.organizers?.count)!
        }
        
        if(section == 2){
            return (self.league.teams?.count)!
        }
        
        if section == 3
        {
            return (self.league.games?.count)!
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
            return "League Games"
        }
        
        
        return ""
    }
    

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        var headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor(colorLiteralRed: 179.0, green: 0.0, blue: 0.0, alpha: 0.7)
        headerView.textLabel?.font = UIFont.boldSystemFontOfSize(20)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0 || indexPath.section == 3)
        {
            return 170
        }else{
            return 70
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Calling tableVIew");
        
        let section = indexPath.section
        let row = indexPath.row

        
        var cell: UITableViewCell = UITableViewCell()
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        if(section == 0)
        {
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
        
        
        else if(section == 1)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("organizerCell", forIndexPath: indexPath)
            if let leagueTableCell = cell as? OrganizerNameTableViewCell {
                
                if let organizers = self.league.organizers?.objectAtIndex(row) as? Organizers {
                    leagueTableCell.organizerName.text = String(organizers.personalInfo!.fname)
                }

            }
            return cell
        }
        
        
        else if(indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("teamCell", forIndexPath: indexPath)
        
            if let team = self.league.teams?.objectAtIndex(row) as? Team {
                if let leagueTableCell = cell as? TeamNameTableViewCell {
                    
                    leagueTableCell.teamName.text = String(team.name!)
                }
                return cell
            }
        }
        
        
        else if(section == 3)
        {
            print("index path section == " + String(indexPath.section) + " row == " + String(indexPath.row))
            
            cell = tableView.dequeueReusableCellWithIdentifier("LeagueGame", forIndexPath: indexPath)
            if let leagueTableCell = cell as? GameCellUITableViewCell {
                
                
                if let game = self.league.games?.objectAtIndex(row) as? Game {
                    leagueTableCell.homeTeam.text = String(game.homeTeam!.name!)
                    leagueTableCell.awayTeam.text = String(game.awayTeam!.name!)
                    leagueTableCell.referee.text = String(((game.referee!.personalInfo?.fname)! as String))
                    
                    leagueTableCell.field.text = String(((game.field!.name)! as String))
                    
                    leagueTableCell.gameDate.text = "\(game.gameDate)"
                    
                    if (game.gameStats?.homeTeamScore != nil && game.gameStats?.homeTeamScore != nil)
                    {
                        leagueTableCell.gameResult.text = "Score  " + String(game.gameStats!.homeTeamScore!) + " : " + String(game.gameStats!.awayTeamScore!);
                    }
                    
                    return leagueTableCell
                }
            }
        }
    
        return cell
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 3
        {
            if self.isReferee{
                return indexPath
            } else{
                return nil
            }
        }
        else{
            return indexPath
        }
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
        
        if segue.identifier == "updateLeagueGame" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! GameCellUITableViewCell)?.row
           
            if let destination  = segue.destinationViewController as? UpdateGameStatTableViewController {
                destination.game = self.league.games?.objectAtIndex(selectedIndex!) as! Game;
            }
        }
    }
}
