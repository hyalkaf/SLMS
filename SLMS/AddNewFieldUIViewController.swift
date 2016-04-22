//
//  AddNewFieldUIViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-21.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class AddNewFieldUIViewController: UIViewController, BackendlessDataDelegate {

    @IBOutlet weak var fieldName: UITextField!
    
    @IBOutlet weak var fieldNumber: UITextField!
    
    @IBOutlet weak var fieldAddress: UITextField!
    
    var league: League = League()
    let backendActions = BEActions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backendActions.delegate = self
        self.league = backendActions.getLeagueByIdSync(String(self.league.objectId!))!
    }
    
    func BackendlessDataDelegateDataIsSaved(result: AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func BackendlessDataDelegateError(fault: Fault!) {
        print("Error while saving the new field")
    }
    
    @IBAction func AddNewField(sender: AnyObject) {
        
        let field = Field()
        field.name = self.fieldName.text
        field.fieldNumber = NSNumber(integer: Int(self.fieldNumber.text!)!)
        field.address = self.fieldAddress.text
        
        self.league.addToFields(field)
        
        self.backendActions.saveLeagueSync(self.league)
    }
}
