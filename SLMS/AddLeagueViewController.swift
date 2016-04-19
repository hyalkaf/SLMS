//
//  AddLeagueViewController.swift
//  SLMS
//
//  Created by Hussein Yahya Al-kaf on 2016-04-18.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class AddLeagueViewController: UIViewController, BackendlessDataDelegate{
    
    // MARK: Properties
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var leagueName: UITextField!
    @IBOutlet weak var numberOfTeams: UITextField!
    @IBOutlet weak var finishDatePicker: UIDatePicker!
    
    var beAction: BEActions = BEActions();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        beAction.delegate = self
        
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        //Transition to another view
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    func BackendlessDataDelegateError(fault: Fault!) {
        // If data wasn't saved to database 
    }
    
    // MARK: Actions
    @IBAction func addToLeague(sender: UIButton) {
        // Check all fields are filled with info
        // TODO: Add dates condition for when they change
        if (leagueName.hasText() &&
            numberOfTeams.hasText())
        {
            // Initialize new league
            var league: League = League()
            
            // Assign UI fields to the league
            league.name = leagueName.text;
            league.numberOfTeams = Int(numberOfTeams.text!);
            league.startDate = startDatePicker.date;
            league.finishDate = finishDatePicker.date;
            // TODO: add organizers, games and teams
            
            // Save league to the datebase
            beAction.saveLeagueSync(league);

        }
        // Display message to user
        else
        {
            
        }
    }
    
}
