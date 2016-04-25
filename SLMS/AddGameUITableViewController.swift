//
//  AddGameUITableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-21.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class AddGameUITableViewController: UITableViewController, BackendlessDataDelegate {

    var league: League = League()
    let backendActions = BEActions()
   
    var referees: [Referee] = []
    var teams: [Team] = []
    var fields: [Field] = []
    
    var selectedReferee = Referee()
    var selectedHomeTeam = Team()
    var selectedAwayTeam = Team()
    var selectedField = Field()
    
    var gameDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backendActions.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.league = backendActions.getLeagueByIdSync(String(self.league.objectId!))!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("")
        // create the alert
        let alert = UIAlertController(title: "Error happened while adding the game", message: "\(fault)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Choose Home Team"
        }
        if section == 1
        {
            return "Choose Away Team"
        }
        if section == 2
        {
            return "Choose  Field"
        }
        if section == 3
        {
            return "Choose  Referee"
        }
        if section == 4
        {
            return "Choose  Time"
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return self.league.teams!.count
        }
        if section == 1
        {
            return self.league.teams!.count
        }
        if section == 2
        {
            return self.league.fields!.count
        }
        if section == 3
        {
            return self.league.referees!.count
        }
        if section == 4
        {
            return 1
        }
        
        return 0
    }
    
    
    @IBAction func addGame(sender: AnyObject) {
        
        print("Saving Game")
        
        if self.selectedHomeTeam.objectId != nil && self.selectedAwayTeam.objectId != nil && self.selectedField.objectId != nil && self.selectedReferee.objectId != nil {
            
            let game = Game()
            game.homeTeam = self.selectedHomeTeam
            game.awayTeam = self.selectedAwayTeam
            game.referee = self.selectedReferee
            game.field = self.selectedField
            game.gameDate = self.gameDate
            
            self.league.addToGames(game)
            backendActions.saveLeagueSync(self.league)
        } else{
            // create the alert
            let alert = UIAlertController(title: "", message: "Make sure, you select, all fields[home team, away team, field, referee, date]", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCellWithIdentifier("gameHomeTeamCell", forIndexPath: indexPath)
            
            if let team = self.league.teams?.objectAtIndex(indexPath.row) as? Team
            {
                cell.textLabel?.text = (team.name!) as String
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            }
           
            
            return cell
        }
        
        if indexPath.section == 1
        {
            cell = tableView.dequeueReusableCellWithIdentifier("gameAwayTeamCell", forIndexPath: indexPath)

            if let team = self.league.teams?.objectAtIndex(indexPath.row) as? Team
            {
                cell.textLabel?.text = (team.name!) as String
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            }
            
            return cell
            
        }
    
        if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCellWithIdentifier("gameFieldCell", forIndexPath: indexPath)
            if let field = self.league.fields?.objectAtIndex(indexPath.row) as? Field
            {
                cell.textLabel?.text = (field.name!) as String
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            }
            
            return cell
        }
     
        if indexPath.section == 3
        {
            cell = tableView.dequeueReusableCellWithIdentifier("gameRefereeCell", forIndexPath: indexPath)

            if let referee = self.league.referees?.objectAtIndex(indexPath.row) as? Referee
            {
                cell.textLabel?.text = ((referee.personalInfo!.fname as String) + " " + (referee.personalInfo!.lname as String)) as String
                
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            }
      
            
            return cell
        }
        
        if indexPath.section == 4
        {
            cell = tableView.dequeueReusableCellWithIdentifier("gameTimeCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "\(gameDate)"
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            return cell
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // This changes the header background
        //view.tintColor = UIColor.darkGrayColor()
        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour
        var headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        headerView.textLabel!.textColor = UIColor(colorLiteralRed: 179.0, green: 0.0, blue: 0.0, alpha: 0.7)
        
        headerView.textLabel?.font = UIFont.boldSystemFontOfSize(20)
        
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            
            if indexPath.section == 0
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    self.selectedHomeTeam = Team()
                }else{
                    let team = self.league.teams?.objectAtIndex(indexPath.row) as! Team
                    
                    if self.selectedAwayTeam.objectId != team.objectId && self.selectedHomeTeam.objectId == nil
                    {
                        cell.accessoryType = .Checkmark
                        self.selectedHomeTeam = team
                    }
                }
            }
            
            if indexPath.section == 1
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    self.selectedAwayTeam = Team()
                }else{
                    let team = self.league.teams?.objectAtIndex(indexPath.row) as! Team

                    if self.selectedHomeTeam.objectId != team.objectId && self.selectedAwayTeam.objectId == nil
                    {
                        cell.accessoryType = .Checkmark
                        self.selectedAwayTeam = team
                    }
                }
            }
            
            
            if indexPath.section == 2
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    self.selectedField = Field()
                }else{
                    
                    if self.selectedField.objectId == nil
                    {
                        cell.accessoryType = .Checkmark
                        self.selectedField = self.league.fields?.objectAtIndex(indexPath.row) as! Field
                    }
                }
            }
            
            if indexPath.section == 3
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    self.selectedReferee = Referee()
                }else{
                    
                    if self.selectedReferee.objectId == nil
                    {
                        cell.accessoryType = .Checkmark
                        self.selectedReferee = self.league.referees?.objectAtIndex(indexPath.row) as! Referee
                    }
                
                }
            }
            
            if indexPath.section == 4
            {
                DatePickerDialog().show("Choose Game Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",  defaultDate: NSDate(), datePickerMode: .Date) {
                    (date) -> Void in
                    
                    print("Date changed" + "\(date)")
                    self.gameDate = date
                    self.tableView.reloadData()
                }
            }
        }
        
        tableView.reloadData()
    }
}
