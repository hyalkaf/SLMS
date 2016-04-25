//
//  PopulateLeagueUITableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-21.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class PopulateLeagueUITableViewController: UITableViewController, BackendlessDataDelegate {
    
    var backendless = Backendless.sharedInstance()
    var referees: [Referee] = []
    var teams: [Team] = []
    var organizers: [Organizers] = []
    
    var selectedReferees: [Referee] = []
    var selectedTeams: [Team] = []
    var selectedOrganizers: [Organizers] = []

    var selectedRefereesChecked: [Bool] = []
    var selectedTeamsChecked: [Bool] = []
    var selectedOrganizersChecked: [Bool] = []
    
    var selectedLeague: League = League()
    let backendActions = BEActions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backendActions.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backendActions.getAllTeamsAsync()
        backendActions.getAllRefsAsync()
        backendActions.getAllOrganizersAsync()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func AllRefsReceived(referees: [Referee]) {
        
        let playerCount = referees.count;
        if playerCount > 0
        {
            for i in 1...playerCount{
                if self.refereeIsEnrolledInThisLeague(referees[i - 1]) == true {
                    self.selectedRefereesChecked.append(true)
                    self.selectedReferees.append(referees[i - 1])
                    
                } else {
                    self.selectedRefereesChecked.append(false)
                }
                
                self.referees.append(referees[i - 1])
            }
        }
        
    
        self.tableView.reloadData()
    }
    
    func AllOrganizerRecieved(organizers: [Organizers]) {
        let playerCount = organizers.count;

        self.selectedOrganizersChecked = [Bool](count: organizers.count, repeatedValue: false)
        
        for i in 1...playerCount{
            if self.organizerIsEnrolledInThisLeague(organizers[i - 1]) == true {
                self.selectedOrganizersChecked[i - 1] = true
                self.selectedOrganizers.append(organizers[i - 1])
                
            } else {
                self.selectedOrganizersChecked[i - 1] = false
            }
            self.organizers.append(organizers[i - 1])
        }
        self.tableView.reloadData()
    }
    

    
    func AllTeamsReceived(teams: [Team]) {
        
        let playerCount = teams.count;
        
        if teams.count > 0 {
            for i in 1...playerCount{
                if teams[i - 1].enrolledInLeague == false {
                    self.teams.append(teams[i - 1])
                    self.selectedTeamsChecked.append(false)
                    
                } else {
                    if teamIsEnrolledInThisLeague(teams[i - 1]){
                        self.teams.append(teams[i - 1])
                        self.selectedTeamsChecked.append(true)
                        self.selectedTeams.append(teams[i - 1])
                    }
                }
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("Error happened while saving the league")
    }
    
    @IBAction func populateLeague(sender: AnyObject) {
        
        let newLeague = backendActions.getLeagueByIdSync(String(self.selectedLeague.objectId!))

        if newLeague?.teams != nil{
            for team in newLeague!.teams! {
                newLeague!.removeFromTeams(team as! Team)
            }
        }
        
        if newLeague?.organizers != nil
        {
            for organizer in newLeague!.organizers! {
                newLeague!.removeFromOrganizers(organizer as! Organizers)
            }
        }
        
        if newLeague?.referees != nil{
            for ref in newLeague!.referees! {
                newLeague!.removeFromReferees(ref as! Referee)
            }
        }

        
        for team in self.selectedTeams
        {
            newLeague!.addToTeams(team)
            
        }
        
        for organizer in self.selectedOrganizers{
            newLeague!.addToOrganizers(organizer)
        }
        
        for ref in self.selectedReferees{
            newLeague!.addToReferees(ref)
        }
        
        self.backendActions.saveLeagueSync(newLeague!)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Add Organizers"
        }
        
        if section == 1
        {
            return "Add Referees"
        }
        
        if section == 2
        {
            return "Add Teams"
        }
        
        return ""
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return self.organizers.count
        }
        
        if section == 1
        {
            return self.referees.count
        }
        if section == 2
        {
            return self.teams.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            
            cell = tableView.dequeueReusableCellWithIdentifier("populateLeagueCell", forIndexPath: indexPath)
            cell.textLabel?.text = String(self.organizers[indexPath.row].personalInfo!.fname)
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            if self.selectedOrganizersChecked[indexPath.row] == true
            {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            return cell
        }
        
        if indexPath.section == 1
        {
            cell = tableView.dequeueReusableCellWithIdentifier("populateLeagueCell", forIndexPath: indexPath)
            cell.textLabel?.text = String(self.referees[indexPath.row].personalInfo!.fname)
            
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            if self.selectedRefereesChecked[indexPath.row] == true
            {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            return cell
        }
        
        if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCellWithIdentifier("populateLeagueCell", forIndexPath: indexPath)
            cell.textLabel?.text = String(self.teams[indexPath.row].name!)
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            if self.selectedTeamsChecked[indexPath.row] == true
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
            
            if indexPath.section == 0
            {
                //Organizers
                if cell.accessoryType == .Checkmark
                {
                    self.selectedOrganizersChecked[indexPath.row] = false
                    for organizer in self.selectedOrganizers
                    {
                        if organizer.objectId == self.organizers[indexPath.row].objectId
                        {
                            self.selectedOrganizers.removeAtIndex(self.selectedOrganizers.indexOf(organizer)!)
                        }
                    }
                    
                }else{
                    self.selectedOrganizersChecked[indexPath.row] = true
                    self.selectedOrganizers.append(self.organizers[indexPath.row])
                }
            }
            
            if indexPath.section == 1
            {
                //Referees
                if cell.accessoryType == .Checkmark
                {
                    for ref in self.selectedReferees
                    {
                        if ref.objectId == self.referees[indexPath.row].objectId
                        {
                            self.selectedReferees.removeAtIndex(self.selectedReferees.indexOf(ref)!)
                        }
                    }
                    
                    self.selectedRefereesChecked[indexPath.row] = false
                    
                }else{
                    self.selectedRefereesChecked[indexPath.row] = true
                    self.selectedReferees.append(self.referees[indexPath.row])
                }
            }
            
            if indexPath.section == 2
            {
                //Teams
                if cell.accessoryType == .Checkmark
                {
                    self.selectedTeamsChecked[indexPath.row] = false
                    
                    for team in self.selectedTeams
                    {
                        if team.objectId == self.teams[indexPath.row].objectId
                        {
                            self.selectedTeams.removeAtIndex(self.selectedTeams.indexOf(team)!)
                        }
                    }
                    
                }else{
                    self.selectedTeamsChecked[indexPath.row] = true
                    self.selectedTeams.append(self.teams[indexPath.row])
                }
            }
        }
        
        tableView.reloadData()
    }

    
    func teamIsEnrolledInThisLeague (team: Team)-> Bool
    {
        if self.selectedLeague.teams != nil{
            for team1 in self.selectedLeague.teams!
            {
                let team2 = team1 as! Team
                if team2.objectId == team.objectId
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func organizerIsEnrolledInThisLeague (organizer: Organizers)-> Bool
    {
        if self.selectedLeague.organizers != nil{
            for organizer1 in self.selectedLeague.organizers!
            {
                let organizer2 = organizer1 as! Organizers
                if organizer2.objectId == organizer.objectId
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    func refereeIsEnrolledInThisLeague (referee: Referee)-> Bool
    {
        if self.selectedLeague.referees != nil {
            for referee1 in self.selectedLeague.referees!
            {
                let referee2 = referee1 as! Referee
                if referee2.objectId == referee.objectId
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // This changes the header background
        //view.tintColor = UIColor.darkGrayColor()
        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour
        var headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        headerView.textLabel!.textColor = UIColor(colorLiteralRed: 179.0, green: 0.0, blue: 0.0, alpha: 0.7)
        
        headerView.textLabel?.font = UIFont.boldSystemFontOfSize(20)
        
    }
}
