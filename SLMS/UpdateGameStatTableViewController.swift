//
//  UpdateGameStatTableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-22.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class UpdateGameStatTableViewController: UITableViewController, BackendlessDataDelegate, UITextFieldDelegate {
    
    var game = Game()
    let backendActions = BEActions()
    
    var homeTeamScoreTextField = UITextField()
    var awayTeamScoreTextField = UITextField()
    var homeTeamScore = "home team score"
    var awayTeamScore = "away team score"
    
    var homeTeamScoreInt = -1
    var awayTeamScoreInt = -1
    
    var canEdit = false
    var gameGoals = [Goal]()
    var gameCards = [Card]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backendActions.delegate = self
        if let homeTS = self.game.gameStats?.homeTeamScore{
            homeTeamScoreTextField.text = String(homeTS)
        }
        if let awayTS = self.game.gameStats?.homeTeamScore{
            awayTeamScoreTextField.text = String(awayTS)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.game = self.backendActions.getGameByIdSync(String(self.game.objectId!))!
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
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
            cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell", forIndexPath: indexPath)
            
            let cgrect = CGRect(x: 10.0, y: 10.0, width: 100, height: 20.0)
            self.homeTeamScoreTextField = UITextField(frame: cgrect)
            self.homeTeamScoreTextField.placeholder = self.homeTeamScore
            cell.contentView.addSubview(self.homeTeamScoreTextField)
            self.homeTeamScoreTextField.delegate = self
            
            let cgrect2 = CGRect(x: 10.0, y: 50.0, width: 100, height: 20.0)
            self.awayTeamScoreTextField = UITextField(frame: cgrect2)
            self.awayTeamScoreTextField.placeholder = self.awayTeamScore
            cell.contentView.addSubview(self.awayTeamScoreTextField)
            self.awayTeamScoreTextField.delegate = self
            
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
        
        if indexPath.section == 3
        {
            cell = tableView.dequeueReusableCellWithIdentifier("SaveGame", forIndexPath: indexPath)
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            return cell
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if indexPath.section == 0
        {
            print("The home goal score == " + self.homeTeamScoreTextField.text!)
            print("The away goal score == " + self.awayTeamScoreTextField.text!)
        }
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
        
        if indexPath.section == 0
        {
            self.homeTeamScore =  self.homeTeamScoreTextField.text!
            self.awayTeamScore = self.awayTeamScoreTextField.text!
            print("The home goal score == " + self.homeTeamScore)
            print("The away goal score == " + self.awayTeamScore)
        }
        
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                //self.canEdit = false
                self.tableView.reloadData()
            }
        }
        
        if indexPath.section == 3
        {
            self.saveGame()
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
    
    
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("Error Saving The Goal")
    }
    
    @IBAction func SaveGameScore(sender: AnyObject) {
        
        self.saveGame()
    }
    
    func saveGame()
    {
        print("saving the game ")
        
        if self.homeTeamScoreInt != -1 && self.awayTeamScoreInt != -1
        {
            if self.game.gameStats == nil{
                self.game.gameStats = GameStat()
            }
            self.game.gameStats?.homeTeamScore = Int(self.homeTeamScore)
            self.game.gameStats?.awayTeamScore = Int(self.awayTeamScore)
            self.game.isPlayed = true
            self.backendActions.saveGameSync(self.game)
            
        } else {
            let alertController = UIAlertController(title: "Error", message:
                "Score can't be empty", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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
    
    
    // MARK: - UITextfield Delegates

    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
            // Create an `NSCharacterSet` set which includes everything *but* the digits
            let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
            
            // At every character in this "inverseSet" contained in the string,
            // split the string up into components which exclude the characters
            // in this inverse set
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            
            // Rejoin these components
            let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
            
            // If the original string is equal to the filtered string, i.e. if no
            // inverse characters were present to be eliminated, the input is valid
            // and the statement returns true; else it returns false
            return string == filtered
            
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.homeTeamScoreTextField
        {
            if textField.text != nil && textField.text != ""
            {
                self.homeTeamScoreInt = Int(textField.text!)!
                print("First Text field " + String(self.homeTeamScoreInt))
            }
        }
        if textField.text != nil && textField.text != ""
        {
            if textField.text != nil
            {
                self.awayTeamScoreInt = Int(textField.text!)!
                print("Second Text field    " + String(self.awayTeamScoreInt))
            }

        }
    }
}
