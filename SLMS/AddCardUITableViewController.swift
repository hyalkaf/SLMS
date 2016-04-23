//
//  AddCardUITableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-22.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class AddCardUITableViewController: UITableViewController, BackendlessDataDelegate {

    var game = Game()
    let backendActions = BEActions()
    var cardTime = NSDate()
    var cardReciever = Player()
    var playerChecked = false
    
    var selectedCard = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backendActions.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.game = self.backendActions.getGameByIdSync(String(self.game.objectId!))!
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Home Team Players"
        }
        if section == 1
        {
            return "Away Team Players"
        }
        if section == 2
        {
            return "Card Type"
        }
        
        if section == 3
        {
            return "Choose Time"
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
            return (self.game.homeTeam?.players?.count)!
        }
        
        if section == 1
        {
            return (self.game.awayTeam?.players?.count)!
        }
        
        if section == 2
        {
            return 2
        }
        
        if section == 3
        {
            return 1
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCellWithIdentifier("homeTeamPlayerCell", forIndexPath: indexPath)
            
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            let player = self.game.homeTeam!.players?.objectAtIndex(indexPath.row) as! Player
            
            cell.textLabel?.text = String((player).personalInfo!.fname) + " " + String((player).personalInfo!.lname)
            
            cell.detailTextLabel?.text = "\(player.number)"
            
            return cell
        }
        
        if indexPath.section == 1
        {
            cell = tableView.dequeueReusableCellWithIdentifier("awayTeamPlayerCell", forIndexPath: indexPath)
            
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            let player = self.game.awayTeam!.players?.objectAtIndex(indexPath.row) as! Player
            cell.textLabel?.text = String((player).personalInfo!.fname) + " " + String((player).personalInfo!.lname)
            
            cell.detailTextLabel?.text = "\(player.number)"
            
            return cell
        }
        
        if indexPath.section == 2
        {
            cell = tableView.dequeueReusableCellWithIdentifier("cardTypeCell", forIndexPath: indexPath)
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            if indexPath.row == 0
            {
                cell.textLabel?.text = "Yellow"
                
                if self.selectedCard == "Yellow"
                {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }

            }
            
            if indexPath.row == 1
            {
                cell.textLabel?.text = "Red"
                if self.selectedCard == "Red"
                {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
            
            return cell
        }
        
        if indexPath.section == 3
        {
            cell = tableView.dequeueReusableCellWithIdentifier("cardTimeCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "\(cardTime)"
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            return cell
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            
            if indexPath.section == 0
            {
                if cell.accessoryType == .Checkmark
                {
                    self.cardReciever = Player()
                    cell.accessoryType = .None
                    self.playerChecked = false
                    
                }else{
                    
                    if self.cardReciever.objectId == nil && self.playerChecked == false
                    {
                        self.cardReciever = self.game.homeTeam!.players?.objectAtIndex(indexPath.row) as! Player
                        cell.accessoryType = .Checkmark
                        self.playerChecked = true
                    }
                }
            }
            
            if indexPath.section == 1
            {
                if cell.accessoryType == .Checkmark
                {
                    self.cardReciever = Player()
                    cell.accessoryType = .None
                    self.playerChecked = false
                    
                }else{
                    
                    if self.cardReciever.objectId == nil && self.playerChecked == false
                    {
                        self.cardReciever = self.game.awayTeam!.players?.objectAtIndex(indexPath.row) as! Player
                        cell.accessoryType = .Checkmark
                        self.playerChecked = true
                    }
                }
            }
            
            if indexPath.section == 2
            {
                if indexPath.row == 0
                {
                    self.selectedCard = "Yellow"
                }
                if indexPath.row == 1
                {
                    self.selectedCard = "Red"
                }

            }
            
            if indexPath.section == 3
            {
                DatePickerDialog().show("Choose Card Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",  defaultDate: NSDate(), datePickerMode: .Time) {
                    (date) -> Void in
                    
                    print("Date changed" + "\(date)")
                    self.cardTime = date
                    self.tableView.reloadData()
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("Error Saving The Goal")
    }
    
    @IBAction func saveCard(sender: AnyObject) {
        let card = Card()
        card.player = self.cardReciever
        card.time = self.cardTime
        card.type = self.selectedCard
        
        if self.game.gameStats == nil{
            self.game.gameStats = GameStat()
        }

        self.game.gameStats!.addToCards(card)
        self.game.isPlayed = true
        self.backendActions.saveGameSync(self.game)
        self.navigationController?.popViewControllerAnimated(true);
    }
}
