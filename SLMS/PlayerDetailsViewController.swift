//
//  PlayerDetailsViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UIViewController {

    var player: Player = Player()
   
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var IS_CAPTAIN = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstName.text = String(player.personalInfo!.fname)
        self.lastName.text = String(player.personalInfo!.lname)
        self.email.text = String(player.personalInfo!.email!)
        self.phone.text = String(player.personalInfo!.phone!)
        self.address.text = String(player.personalInfo!.address!)
        
        if(!self.IS_CAPTAIN){
            self.title = String(player.personalInfo!.fname)
        } else{
            self.title = "Team Captain"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
