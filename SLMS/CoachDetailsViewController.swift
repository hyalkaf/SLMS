//
//  CoachDetailsViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class CoachDetailsViewController: UIViewController {

    var coach: Coach = Coach()
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        self.firstName.text = String(coach.personalInfo!.fname)
        self.lastName.text = String(coach.personalInfo!.lname)
        self.email.text = String(coach.personalInfo!.email!)
        self.phone.text = String(coach.personalInfo!.phone!)
        self.address.text = String(coach.personalInfo!.address!)
        
        self.title = "Team Coach"
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
