//
//  OrganizerDetailsViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class OrganizerDetailsViewController: UIViewController {

    var organizer: Organizers = Organizers()
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.firstName.text = String(organizer.personalInfo!.fname)
        self.lastName.text = String(organizer.personalInfo!.lname)
        self.email.text = String(organizer.personalInfo!.email!)
        self.phone.text = String(organizer.personalInfo!.phone!)
        self.address.text = String(organizer.personalInfo!.address!)
        
        self.title = "League Organizer"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
