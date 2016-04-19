//
//  Person.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import Foundation


class Person : NSObject
{
    
    // MARK: Properties
    var created: NSDate = NSDate()
    var updated: NSDate = NSDate()
    var objectId: NSString?
    var ownerId: NSString?
    
    var fname: NSString = ""
    var lname: NSString = ""
    var email: NSString?
    var address: NSString?
    var phone: NSString?
}