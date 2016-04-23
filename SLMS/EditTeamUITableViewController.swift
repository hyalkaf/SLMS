//
//  EditTeamUITableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-22.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class EditTeamUITableViewController: UITableViewController, BackendlessDataDelegate, UITextFieldDelegate {

    var team: Team = Team()
    let backendActions = BEActions()
    var PlayersList = [Player]()
    var selectedPlayers = [Player]()
    
    var checked = [Bool]()
    var captianChecked = [Bool]()
    
    var captainCheckedObjectId : NSString = "-1"
    var chosenCaptain = Player()

    var teamName = UITextField()
    var teamNameText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("SElF")
        let objectID = self.team.objectId!
        self.team = self.backendActions.getTeamByIdSync(String(objectID))!
        self.teamNameText = String(self.team.name)
        self.captainCheckedObjectId = (self.team.captain?.objectId)!
        self.chosenCaptain = self.team.captain!
        backendActions.delegate = self
        backendActions.getAllPlayersAsync()
     }
    
    func AllPlayersReceived(players: [Player]) {
       
        let playerCount = players.count - 1;
        
        if playerCount > 0
        {
            for player1 in players
            {
                if player1.hasTeam == false {
                    self.PlayersList.append(player1)
                    self.checked.append(false)
                } else {
                    
                    for player in self.team.players!
                    {
                        let player = player as! Player
                        if player.objectId == player1.objectId
                        {
                            self.PlayersList.append(player1)
                            self.selectedPlayers.append(player1)
                            self.checked.append(true)
                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 100
        }
        
        else
        {
            return 75
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0
        {
            return "Team Name"
        }
        if section == 1
        {
            return "Team Coach"
        }
        if section == 2
        {
            return "Team Captain"
        }
        
        if section == 3
        {
            return "Team Players"
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(section == 0){
            return 1
        }
        
        if(section == 1){
            return 1
        }
        
        if(section == 2){
            return self.selectedPlayers.count + 1
        }
        
        if(section == 3){
            return self.PlayersList.count
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if(indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("teamNameInput", forIndexPath: indexPath)
            let cgrect = CGRect(x: 10.0, y: 10.0, width: 400, height: 70.0)
            self.teamName = UITextField(frame: cgrect)
            self.teamName.placeholder = self.teamNameText
            self.teamName.backgroundColor = UIColor.grayColor()
            self.teamName.textColor = UIColor.whiteColor()
            
            cell.contentView.addSubview(self.teamName)
            
            self.teamName.delegate = self
            
            
            return cell
        }
        
        
        if(indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("teamCoachCell", forIndexPath: indexPath)
            let coach = self.team.coach!.personalInfo!
            cell.textLabel?.text = String(coach.fname)
            
            return cell
        }
        
        if(indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("teamCaptainCell", forIndexPath: indexPath)
            if indexPath.row == 0
            {
                let captain = self.team.captain?.personalInfo!
                cell.textLabel!.text = String(captain!.fname)
                
                if captainCheckedObjectId == self.team.captain?.objectId
                {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
                
                
            } else {
                let captain = self.selectedPlayers[indexPath.row - 1]
                cell.textLabel!.text = String(captain.personalInfo!.fname)
                
                if captainCheckedObjectId == captain.objectId
                {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
            
            return cell
        }
        
        if(indexPath.section == 3){
            cell = tableView.dequeueReusableCellWithIdentifier("teamPlayersCell", forIndexPath: indexPath)
            let player = (self.PlayersList[indexPath.row])
            cell.textLabel!.text = String(player.personalInfo!.fname)
            
            
            if !self.checked[indexPath.row] {
                cell.accessoryType = .None
            } else if self.checked[indexPath.row]{
                cell.accessoryType = .Checkmark
            }
            
            return cell
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if indexPath.section == 2
            {
                if indexPath.row == 0
                {
                    self.captainCheckedObjectId = (self.team.captain?.objectId)!
                    self.chosenCaptain = self.team.captain!
                } else {
                    let captain = self.selectedPlayers[indexPath.row - 1]
                    self.captainCheckedObjectId = captain.objectId!
                    self.chosenCaptain = captain
                }
            }
            
            if indexPath.section == 3
            {
                if cell.accessoryType == .Checkmark
                {
                    cell.accessoryType = .None
                    self.checked[indexPath.row] = false
                    updateCaptainOptions(indexPath, add: false)
                    
                }else{
                    cell.accessoryType = .Checkmark
                    self.checked[indexPath.row] = true
                    updateCaptainOptions(indexPath, add: true)
                }
                
            }
        }
        tableView.reloadData()
    }
    
    func updateCaptainOptions(indexPath: NSIndexPath, add: Bool)
    {
        if add
        {
            self.selectedPlayers.append(self.PlayersList[indexPath.row])
            //self.captianChecked.append(false)
        }
        else
        {
            let itemToRemove = self.PlayersList[indexPath.row]
            let playerCout = self.selectedPlayers.count
            
            for i in 0...playerCout{
                if self.selectedPlayers[i].objectId == itemToRemove.objectId{
                    self.selectedPlayers.removeAtIndex(i)
                    
                    break
                }
            }
        }
    }
    


    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.teamName
        {
            if textField.text != nil && textField.text != ""
            {
                self.teamNameText = textField.text!
                print("First Text field " + self.teamNameText)
                self.tableView.reloadData()
            }
        }
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        
        if let updateTeam = result as? Team{
            self.navigationController?.popViewControllerAnimated(true);
        }
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("Error Saving The Goal")
    }
    
    
    @IBAction func SaveTeam(sender: AnyObject) {
        
        //let updatedTeam = Te
        
        let updatedTeam = self.team
        
        for player in self.team.players!
        {
            let player = player as! Player
            player.hasTeam = false
            self.backendActions.savePlayerAsync(player)
            updatedTeam.removeFromPlayers(player)
        }
        
        for player in self.selectedPlayers
        {
            player.hasTeam = true
            updatedTeam.addToPlayers(player)
        }
        
        updatedTeam.captain = self.chosenCaptain
        updatedTeam.name = self.teamNameText
        
        //Save the updated Team
        self.backendActions.saveTeamSync(updatedTeam)
    }
}
