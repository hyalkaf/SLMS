//
//  ProfileViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-23.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentUser = backendless.userService.currentUser
        
        if currentUser != nil{
            self.userEmail.text = currentUser.email
            self.firstName.text = currentUser.getProperty("fname") as? String
            self.lastName.text = currentUser.getProperty("lname") as? String
            self.phone.text = currentUser.getProperty("phone") as? String
            self.role.text = currentUser.getProperty("role") as? String
            self.address.text = currentUser.getProperty("address") as? String
            self.password.text = currentUser.password
        }
        
        self.navigationItem.setHidesBackButton(true, animated:true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func updateProfile(sender: AnyObject) {
       
       self.updateUserPropsSync()
    }
    
    
    func updateUserPropsSync() {
        
        let currentUser = self.backendless.userService.currentUser

        Types.tryblock({ () -> Void in
    
            currentUser.setProperty("role", object: self.role.text)
            
            let updatedUser = self.backendless.userService.update(currentUser)
                print("User updated (SYNC): \(updatedUser)")
            
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception)" )
        })
    }
}
