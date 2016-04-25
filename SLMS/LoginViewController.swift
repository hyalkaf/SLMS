import UIKit

class LoginViewController: UIViewController, BackendlessDataDelegate {
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var KeepUserLoggedIn = true
    var backendless = Backendless.sharedInstance()
    let backendAction = BEActions()
    let user = BackendlessUser()
    
    var validUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendAction.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func LogIn(sender: AnyObject) {
        
        self.LogIn()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showUserProfile"
        {
            if self.validUser == true
            {
                return true
            } else{
                return false
            }
        }
        
        return true
    }
    
    
    func LogIn()
    {
        Types.tryblock({ () -> Void in
            
            let user = self.backendless.userService.login(self.userEmail.text, password: self.password.text)
                print("User has been logged in (SYNC): \(user)")
                self.backendless.userService.setStayLoggedIn(true)
                self.validUser = true
            },
            
            catchblock: { (exception) -> Void in
                print("Login - Server reported an error: \(exception as! Fault)")
                
                // create the alert
                let alert = UIAlertController(title: "Log in Error", message: "\(exception as! Fault)", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                // show the alert
                self.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
}
