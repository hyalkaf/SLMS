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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beactions.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.beactions.getAllTeamsAsync()
        
    }
    
    func AllTeamsReceived(teams: [Team]) {
        self.teams = teams
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    
    //TeamCellIdentifier
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier("TeamCellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = String(self.teams[indexPath.row].name!)
        
        return cell
    }
    
}
