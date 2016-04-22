//
//  CreateAccountViewController.swift
//  example
//
//  Created by Nabil Ali Muthanna  on 2016-02-07.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userUserName: UITextField!
    
    let TOSUrl = "http://www.briotie.com/"
    var KeepUserLoggedIn = true
    var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func SignUp(sender: AnyObject) {
        // create the alert
        let alert = UIAlertController(title: "Terms of Service", message: "By creating an account, you agree to the Briotie Terms of Service", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "I Agree", style: UIAlertActionStyle.Default, handler: { action in
            self.registerUser()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Read Terms of Service", style: UIAlertActionStyle.Default, handler: { action in
            //Redirct user to the web page that contains the terms of service
            let url = NSURL(string: self.TOSUrl)!
            UIApplication.sharedApplication().openURL(url)
        }))
    
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func registerUser() {
        Types.tryblock({ () -> Void in
            
            let user = BackendlessUser()
            user.email = self.userEmail.text
            user.password = self.userPassword.text
            user.setProperty("userName", object: self.userUserName.text)
            user.setProperty("profileImagePath", object: "https://api.backendless.com/91e8bcd4-830e-f6f7-ff74-410d17641a00/v1/files/users/profileImages/default.png")
            user.setProperty("description", object: "No description is added.")

            
            let registeredUser = self.backendless.userService.registering(user)
            print("User has been registered \(registeredUser)")
            
            //Set as the current user
            self.backendless.userService.login(user.email, password: user.password)
            self.backendless.userService.setStayLoggedIn(self.KeepUserLoggedIn);
            
            //TODO - Transition to Profile Tab
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("profile") as UIViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
        },
            
        catchblock: { (exception) -> Void in
            if(exception.faultCode == "3041")
            {
                let alert = UIAlertController(title: "", message: "Missing one of the rquired values", preferredStyle: UIAlertControllerStyle.Alert)
                    
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                    }))
                    
                self.presentViewController(alert, animated: true, completion: nil)
            }
                
            if(exception.faultCode == "3033")
            {
                let alert = UIAlertController(title: "", message: "User with the same information already exists",preferredStyle: UIAlertControllerStyle.Alert)
            
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
                
            if(exception.faultCode == "3011")
            {
                let alert = UIAlertController(title: "", message: "Password is missing", preferredStyle: UIAlertControllerStyle.Alert)
                    
                alert.addAction(UIAlertAction(title: "Ok", style:
                    UIAlertActionStyle.Default, handler: { action in
                }))
                self.presentViewController(alert, animated: true, completion: nil)

            }
                
            if(exception.faultCode == "3040")
            {
                let alert = UIAlertController(title: "", message: "Email address is in the wrong format.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
}
