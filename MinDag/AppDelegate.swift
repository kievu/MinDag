//
//  AppDelegate.swift
//  Mathys
//
//  Created by ingeborg ødegård oftedal on 15/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit
import ResearchKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.tintColor = Color.primaryColor
        application.applicationIconBadgeNumber = 0
        
        let completedOnboarding = UserDefaults.boolForKey(UserDefaultKey.CompletedOnboarding)
        
        let onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingVC = onboarding.instantiateInitialViewController()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = main.instantiateInitialViewController()
        
        window?.rootViewController = completedOnboarding ? mainVC : onboardingVC
        
        let hasLaunchedBefore = UserDefaults.boolForKey(UserDefaultKey.hasLaunchedBefore)
        if !hasLaunchedBefore  {
            let uuid = NSUUID().UUIDString
            UserDefaults.setObject(uuid, forKey: UserDefaultKey.UUID)
            print("Stored user ID \(uuid) in UserDefaults")
            
            ORKPasscodeViewController.removePasscodeFromKeychain()
            print("Removed passcode from Keychain")
            
            UserDefaults.setBool(true, forKey: UserDefaultKey.hasLaunchedBefore)
            print("HasLaunched flag enabled in UserDefaults")
            
        }
        
        lock()
        
        return true
    }
    
    func lock() {
        guard ORKPasscodeViewController.isPasscodeStoredInKeychain()
            && !(window?.rootViewController?.presentedViewController is ORKPasscodeViewController)
            && UserDefaults.boolForKey(UserDefaultKey.CompletedOnboarding)
            else { return }
        
        window?.makeKeyAndVisible()
        
        let passcodeVC = ORKPasscodeViewController.passcodeAuthenticationViewControllerWithText("Velkommen tilbake til Min Dag.", delegate: self) as! ORKPasscodeViewController
        window?.rootViewController?.presentViewController(passcodeVC, animated: false, completion: nil)
    }
    
    
    
    // MARK: Notification delegates
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        // This method is called when the app is launched (either normally or due to a local notification’s action)
        // This method can become useful in cases you need to check the existing settings and act depending on the values that will come up. Don’t forget that users can change these settings through the Settings app, so do never be confident that the initial configuration made in code is always valid.
        
        print(notificationSettings.types.rawValue)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // This method is called when a notification has been received while the app is in the foreground
        print("Received Local Notification:")
        print(notification.alertBody)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        let type = notification.userInfo!["type"] as! String
        
        application.applicationIconBadgeNumber = 0

        if identifier == "GO_ACTION" {
            if      type == "dailySurvey"   { NSNotificationCenter.defaultCenter().postNotificationName("presentDailySurvey", object: nil) }
            else if type == "weeklySurvey"  { NSNotificationCenter.defaultCenter().postNotificationName("presentWeeklySurvey", object: nil) }
        }
        
        completionHandler()
    }
    
    
    
    // MARK: Other lifecycle delegate methods

    func applicationWillResignActive(application: UIApplication) {
        // TODO: SplashView
        /*if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            // Hide content so it doesn't appear in the app switcher.
            
        }*/
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        lock()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: ORKPasscodeDelegate {
    func passcodeViewControllerDidFinishWithSuccess(viewController: UIViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func passcodeViewControllerDidFailAuthentication(viewController: UIViewController) {
        // Todo
    }
}

