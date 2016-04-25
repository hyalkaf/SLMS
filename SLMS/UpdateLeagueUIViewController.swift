//
//  UpdateLeagueUIViewController.swift
//  SLMS
//
//  Created by Hussein Yahya Al-kaf on 2016-04-18.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

class UpdateLeagueUIViewController: UIViewController, BackendlessDataDelegate {

    // MARK: Properties
    @IBOutlet weak var updateLeagueName: UITextField!
    @IBOutlet weak var updatedNumberOfLeagueTeams: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var finishDatePicker: UIDatePicker!
    
    var beAction: BEActions = BEActions();
    var leagueToUpdate: League = League();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beAction.delegate = self
       
        self.updatedNumberOfLeagueTeams.text = self.leagueToUpdate.numberOfTeams?.stringValue
        self.updateLeagueName.text = String(self.leagueToUpdate.name!)
//        self.startDatePicker.setDate(self.leagueToUpdate.startDate, animated: true)
//        self.finishDatePicker.setDate(self.leagueToUpdate.finishDate, animated: true)
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        //Transition to another view
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.leagueToUpdate = beAction.getLeagueByIdSync(String(self.leagueToUpdate.objectId!))!
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        // If data wasn't saved to database
        print("fServer reported an error: \(fault)")
        
    }
    
    // MARK: Actions
    @IBAction func UpdateLeagueAction(sender: UIButton) {
        // Check all fields are filled with info
        // TODO: Add dates condition for when they change
        if (updateLeagueName.hasText() &&
            updatedNumberOfLeagueTeams.hasText())
        {
            
            // Assign UI fields to the league
            leagueToUpdate.name = updateLeagueName.text;
            leagueToUpdate.numberOfTeams = Int(updatedNumberOfLeagueTeams.text!);
            leagueToUpdate.startDate = startDatePicker.date;
            leagueToUpdate.finishDate = finishDatePicker.date;
            // TODO: add organizers, games and teams
            
            // Save league to the datebase
            if (leagueToUpdate.objectId != nil)
            {
                beAction.saveLeagueSync(leagueToUpdate);
            }
            
        }
            // Display message to user
        else
        {
            
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "populateLeague" {
            
            if let destination  = segue.destinationViewController as? PopulateLeagueUITableViewController {
                destination.selectedLeague = self.leagueToUpdate
            }
        }
        
        
        if segue.identifier == "addNewField" {
            
            if let destination  = segue.destinationViewController as? AddNewFieldUIViewController {
                destination.league = self.leagueToUpdate
            }
        }
        
        if segue.identifier == "addGameToLeague" {
            
            if let destination  = segue.destinationViewController as? AddGameUITableViewController {
                destination.league = self.leagueToUpdate
            }
        }
        
    }
}
