//
//  TeamDetailsUITableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-22.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class TeamDetailsUITableViewController: UITableViewController {
    var backendless = Backendless.sharedInstance()
    let backendActions = BEActions()

    @IBOutlet weak var editTeamBtn: UIBarButtonItem!
    
    
    var team: Team = Team()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = backendless.userService.currentUser
        
        if currentUser != nil{
            let role = currentUser.getProperty("role") as! String
            if role != "Coach"
            {
                self.editTeamBtn.title = ""
                self.editTeamBtn.style = UIBarButtonItemStyle.Plain
                self.editTeamBtn.enabled = false
            }
        }
        
        self.title = team.name! as String
    }
    
    override func viewWillAppear(animated: Bool) {
        let objectID = self.team.objectId!
        self.team = self.backendActions.getTeamByIdSync(String(objectID))!
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
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        
        if(indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("coachNameCell", forIndexPath: indexPath)
            let coach = self.team.coach!.personalInfo!
            cell.textLabel?.text = String(coach.fname)
            
            return cell
        }
        
        else if(indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("captainNameCell", forIndexPath: indexPath)
            let captain = self.team.captain!.personalInfo!
            cell.textLabel!.text = String(captain.fname)

            return cell
        }
        
        else if(indexPath.section == 2){
            let player = self.team.players?.objectAtIndex(indexPath.row) as! Player
            cell = tableView.dequeueReusableCellWithIdentifier("playerNameCell", forIndexPath: indexPath)
            cell.textLabel!.text = String(player.personalInfo!.fname)
            
            return cell
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editTeamSegue" {
            
            if let destination  = segue.destinationViewController as? EditTeamUITableViewController {
                destination.team = (self.team)
            }
        }
        
    }
}
