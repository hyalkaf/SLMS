//
//  AppDelegate.swift
//  SLMS
//
//  Created by Nabil Ali Muthanna  on 2016-04-17.
//  Copyright © 2016 Nabil Ali Muthanna . All rights reserved.
//

import UIKit
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backendless = Backendless.sharedInstance()

    let APP_ID = "F947B349-B9B4-284A-FF63-F527C196DF00"
    let SECRET_KEY = "EBEB3869-72ED-1AF6-FF89-324E25BDAD00"
    let VERSION_NUM = "v1"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        if(backendless.userService.currentUser == nil)
        {
            createTutorialSlides()
        }
        
        return true
    }


    
    
    func createTutorialSlides ()
    {
        //Create the tutorial slide shows
        let firstPage = OnboardingContentViewController(title: "What is SLMS?",
            body: "SLMS lets Add Leagues and organize them!",
            image: nil,
            buttonText: nil) { () -> Void in
        }
        firstPage.movesToNextViewController = true;
        
        let secondPage = OnboardingContentViewController(title: "Adding Team",
            body: "SLMS allows you to add teams!",
            image: nil,
            buttonText: nil) { () -> Void in
        }
        secondPage.movesToNextViewController = true
        
        
        let thirdPage = OnboardingContentViewController(title: "Add Players", body: "SLMS allows you to add payers to teams", image: nil, buttonText: "Create account") { () -> Void in
            
            let creatAccountController = CreateAccountViewController()
            self.window?.rootViewController = creatAccountController
        }
        
        
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "backgroundImage.jpg"), contents: [firstPage, secondPage, thirdPage])
        onboardingVC.shouldFadeTransitions = true
        onboardingVC.fadePageControlOnLastPage = true
        onboardingVC.fadeSkipButtonOnLastPage = true
        onboardingVC.shouldMaskBackground = true
        
        onboardingVC.fontName = "Helvetica-Light"
        onboardingVC.titleFontSize = 30;
        onboardingVC.bodyFontSize = 20;
        onboardingVC.titleTextColor = UIColor.orangeColor()
        
        onboardingVC.skipButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        onboardingVC.buttonTextColor = UIColor.orangeColor()
        
        
        onboardingVC.allowSkipping = true
        onboardingVC.skipHandler = {
            let creatAccountController = CreateAccountViewController()
            self.window?.rootViewController = creatAccountController
        }
        
        self.window?.rootViewController = onboardingVC;
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

