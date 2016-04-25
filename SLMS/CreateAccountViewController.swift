//
//  CreateAccountViewController.swift
//  example
//
//  Created by Nabil Ali Muthanna  on 2016-02-07.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, BackendlessDataDelegate {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var validUser = false
    
    var KeepUserLoggedIn = true
    var backendless = Backendless.sharedInstance()
    let backendAction = BEActions()
    let user = BackendlessUser()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendAction.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func SignUp(sender: AnyObject) {

        self.registerSLMSUser()
    }

    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        
        print("Temp")
        
        Types.tryblock({ () -> Void in
            
            let user = self.backendless.userService.login(self.userEmail.text, password: self.password.text)
                print("User has been logged in (SYNC): \(user)")
                self.backendless.userService.setStayLoggedIn(true)
            },
            
            catchblock: { (exception) -> Void in
                print("Login - Server reported an error: \(exception as! Fault)")
        })

        self.validUser = true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showUserProfile"
        {
            if self.validUser == true
            {
                return true
            }
        }
        
        return false
    }
    
    
    
    
    
    func registerSLMSUser()
    {
        self.user.email = self.userEmail.text
        self.user.password = self.password.text
        
        self.user.setProperty("fname", object: self.firstName.text)
        self.user.setProperty("lname", object: self.lastName.text)
        self.user.setProperty("address", object: self.address.text)
        self.user.setProperty("phone", object: self.phone.text)
        self.user.setProperty("role", object: self.role.text)
        
        backendless.userService.registering(self.user,
            response: { (registeredUser : BackendlessUser!) -> () in
                print("User has been registered (ASYNC): \(registeredUser)")
                
                let person = Person()
                person.fname = self.firstName.text!
                person.lname = self.lastName.text!
                person.email = self.userEmail.text
                person.phone = self.phone.text
                person.address = self.address.text
                
                
                //Add the user with his role
                if self.role.text == "Player"{
                    //Save this user as player
                    let player: Player = Player()
                    player.personalInfo = person
                    self.backendAction.savePlayerAsync(player)
                }
                if self.role.text == "Coach"
                {
                    let coach = Coach()
                    coach.personalInfo = person
                    self.backendAction.saveCoachAsync(coach)
                }
                
                if self.role.text == "Organizer"
                {
                    let organizer = Organizers()
                    organizer.personalInfo = person
                    self.backendAction.saveOrganizerAsync(organizer)
                }
                
                if self.role.text == "Referee"
                {
                    let ref = Referee()
                    ref.personalInfo = person
                    self.backendAction.saveRefereeAsync(ref)
                }
            },
            
            
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare for segue is called  with identidier == " )
    }
}
