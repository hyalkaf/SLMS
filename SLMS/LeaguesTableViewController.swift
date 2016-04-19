//
//  LeaguesTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class LeaguesTableViewController: UITableViewController, BackendlessDataDelegate{

    var backendless = Backendless.sharedInstance()
    var leagues: [League] = []
    var selectedLeague: League = League()
    let backendActions = BEActions()

    
    let APP_ID = "F947B349-B9B4-284A-FF63-F527C196DF00"
    let SECRET_KEY = "EBEB3869-72ED-1AF6-FF89-324E25BDAD00"
    let VERSION_NUM = "v1"

    var selectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
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
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
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
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("Selecting league " + String(self.leagues[indexPath.row].name))
        self.selectedCell = indexPath.row
        self.selectedLeague = self.leagues[indexPath.row]
        print("This league Name is[] " + String(self.selectedLeague.name))
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showLeagueDetail" {
            let selectedIndex = self.tableView.indexPathForCell(sender as! LeaguesTableViewCell)?.row
            
            print(String(selectedIndex));
            if let destination  = segue.destinationViewController as? LeagueDetailTableViewController {
                destination.league = self.leagues[selectedIndex!]
                print("This league Name is[] " + String(self.selectedLeague.name))
            }
        }
    }
}
