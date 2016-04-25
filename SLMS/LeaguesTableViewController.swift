//
//  LeaguesTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class LeaguesTableViewController: UITableViewController, BackendlessDataDelegate{

    @IBOutlet weak var addLeagueBtn: UIBarButtonItem!
    
    var backendless = Backendless.sharedInstance()
    var leagues: [League] = []
    var selectedLeague: League = League()
    let backendActions = BEActions()


    var selectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = backendless.userService.currentUser
        
        if currentUser != nil{
            let role = currentUser.getProperty("role") as! String
            if role != "Organizer"
            {
                self.addLeagueBtn.title = ""
                self.addLeagueBtn.style = UIBarButtonItemStyle.Plain
                self.addLeagueBtn.enabled = false
            }
        }
        
        self.title = "All Leagues"
        self.tableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backendActions.delegate = self
        print("Getting ALL leagues")
        backendActions.getAllLeaguesAsync()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func AllLeaguesReceived(leagues: [League]) {
        print("updating leagues")
        self.leagues = leagues
        self.tableView.reloadData()
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("Error happened while removing the league")
        // create the alert
        let alert = UIAlertController(title: "Error happened while removing the league", message: "\(fault)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leagues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Calling tableVIew");
        let cell: UITableViewCell
   

        cell = tableView.dequeueReusableCellWithIdentifier("leagueCell", forIndexPath: indexPath)
        if let leagueTableCell = cell as? LeaguesTableViewCell {
            
            leagueTableCell.leagueName.text = String(self.leagues[indexPath.row].name!)
            leagueTableCell.numberOfTeams.text = String(self.leagues[indexPath.row].numberOfTeams!)
            let formater = NSDateFormatter()
            formater.dateStyle = .MediumStyle
            formater.timeStyle = .ShortStyle
            
            leagueTableCell.startDate.text = String(formater.stringFromDate(self.leagues[indexPath.row].startDate))
            
            leagueTableCell.finishDate.text = String(formater.stringFromDate(self.leagues[indexPath.row].finishDate))
            
            leagueTableCell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
            
            cell.accessoryType = .DisclosureIndicator
            
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("Selecting league " + String(self.leagues[indexPath.row].name))
        self.selectedCell = indexPath.row
        self.selectedLeague = self.leagues[indexPath.row]
        print("This league Name is[] " + String(self.selectedLeague.name))
        
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            backendActions.removeLeagueSync(self.leagues[indexPath.row])
            self.leagues.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showLeagueDetail" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! LeaguesTableViewCell)?.row
            
            print(String(selectedIndex));
            if let destination  = segue.destinationViewController as? LeagueDetailTableViewController {
                destination.league = self.leagues[selectedIndex!]
            }
        }
    }
}
