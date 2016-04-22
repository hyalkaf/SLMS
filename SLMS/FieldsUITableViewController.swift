//
//  FieldUITableViewController.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-21.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//


class FieldsUITableViewController: UITableViewController, BackendlessDataDelegate {

    
    var backendless = Backendless.sharedInstance()
    var fields: [Field] = []
   
    var league: League = League()
    let backendActions = BEActions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backendActions.delegate = self
        backendActions.getAllFieldsAsync()
        self.league = backendActions.getLeagueByIdSync(String(self.league.objectId!))!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func AllFieldsRecieved(fields: [Field]) {
        
        //TODO filter fields based on the current user
        if (true)
        {
            self.fields = fields
        }
        
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fields.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell

        cell = tableView.dequeueReusableCellWithIdentifier("fieldCell", forIndexPath: indexPath)
        if let leagueTableCell = cell as? FieldCellUITableViewCell {
            
            leagueTableCell.fieldName.text = String(self.fields[indexPath.row].name!)
            leagueTableCell.fieldNumber.text = String(self.fields[indexPath.row].fieldNumber!)
            leagueTableCell.fieldAddress.text = String(self.fields[indexPath.row].address!)
            
            leagueTableCell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
        }
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addNewField" {
            
            if let destination  = segue.destinationViewController as? AddNewFieldUIViewController {
                destination.league = self.league
            }
        }
    }
}
