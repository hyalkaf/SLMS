//
//  TeamsListTableViewController.swift
//  SLMS
//
//  Created by Amjad Al-absi on 4/19/16.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class TeamsListTableViewController: UITableViewController, BackendlessDataDelegate {
    
    let beactions = BEActions()
    var teams = [Team]()
    
    @IBOutlet weak var addTeamBtn: UIBarButtonItem!
    
    var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.beactions.delegate = self
        
        let currentUser = backendless.userService.currentUser
        
        if currentUser != nil{
            let role = currentUser.getProperty("role") as! String
            if role != "Coach"
            {
                self.addTeamBtn.title = ""
                self.addTeamBtn.style = UIBarButtonItemStyle.Plain
                self.addTeamBtn.enabled = false
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //Get All Teams
        self.beactions.getAllTeamsAsync()
    }
    
    func AllTeamsReceived(teams: [Team]) {
        self.teams = teams
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    //TeamCellIdentifier
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier("TeamCellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = String(self.teams[indexPath.row].name!)
        
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTeamDetails" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)?.row
            
            if let destination  = segue.destinationViewController as? TeamDetailsUITableViewController
            {
                destination.team = self.teams[selectedIndex!]
            }
        }
    }
}
