//
//  UpdateGameStatTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-22.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class UpdateGameStatTableViewController: UITableViewController, BackendlessDataDelegate {
    
    var game = Game()
    let backendActions = BEActions()
    var homeTeamScoreTextField = UITextField()
    var awayTeamScoreTextField = UITextField()
    var canEdit = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backendActions.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.game = self.backendActions.getGameByIdSync(String(self.game.objectId!))!
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Game Score"
        }
        if section == 1
        {
            return "Game Goals"
        }
        if section == 2
        {
            return "Game Cards"
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        
        if section == 1
        {
            if self.game.isPlayed == false
            {
                return 0
            }
            
            else if self.game.gameStats != nil
            {
                if self.game.gameStats?.goals != nil
                {
                    return (self.game.gameStats!.goals?.count)! + 1
                }
            }
                
            else {
                return 0
            }
        }
        
        if section == 2
        {
            if self.game.isPlayed == false
            {
                return 0
            }
                
            else if self.game.gameStats != nil
            {
                if self.game.gameStats?.cards != nil
                {
                    return (self.game.gameStats!.cards?.count)!
                }
            }
                
            else {
                return 0
            }
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath)
            
            let cgrect = CGRect(x: 10.0, y: 10.0, width: 100, height: 20.0)
            self.homeTeamScoreTextField = UITextField(frame: cgrect)
            self.homeTeamScoreTextField.placeholder = "Home Team score"
            cell.contentView.addSubview(self.homeTeamScoreTextField)
            
            let cgrect2 = CGRect(x: 10.0, y: 50.0, width: 100, height: 20.0)
            self.awayTeamScoreTextField = UITextField(frame: cgrect2)
            self.awayTeamScoreTextField.placeholder = "Away Team score"
            cell.contentView.addSubview(self.awayTeamScoreTextField)
            
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            return cell
        }
        
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCellWithIdentifier("AddGoalCell", forIndexPath: indexPath)
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
                cell.textLabel!.text = "Reorder Goals Chronologically"
                
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("AddGoalCell", forIndexPath: indexPath)
                cell.contentView.layer.borderWidth = 3
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
                
                cell.textLabel?.text = String((self.game.gameStats?.goals?.objectAtIndex(indexPath.row - 1) as! Goal).player?.personalInfo!.fname) + " " + String((self.game.gameStats?.goals?.objectAtIndex(indexPath.row - 1) as! Goal).player?.personalInfo!.lname)
                cell.editing = self.canEdit
            }
        }
        
        if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCellWithIdentifier("AddCard", forIndexPath: indexPath)
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            cell.textLabel?.text = String((self.game.gameStats?.cards?.objectAtIndex(indexPath.row) as! Card).player?.personalInfo!.fname) + " " + String((self.game.gameStats!.cards?.objectAtIndex(indexPath.row) as! Card).player?.personalInfo!.lname)
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                self.canEdit = true
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                self.canEdit = false
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 1
        {
            if indexPath.row > 0 {
                return true
            }
        }
        
        return false
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 1
        {
            if indexPath.row > 0
            {
                return true
            }
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddGoal" {
            if let destination  = segue.destinationViewController as? AddGoalUITableViewController {
                destination.game = self.game
            }
        }
        
        if segue.identifier == "AddCard" {
            
            if let destination  = segue.destinationViewController as? AddCardUITableViewController {
                 destination.game = self.game
            }
        }
    }
    
    
}
