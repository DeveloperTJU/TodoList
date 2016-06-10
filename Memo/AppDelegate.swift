//
//  AppDelegate.swift
//  Memo
//
//  Created by hui on 16/5/18.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

struct UserInfoStruct {
    var nickName:String = ""
    var UID:String = ""
    var phoneNumber:String = ""
}

var UnfinishedVC:UnfinishedViewController!
var FinishedVC:FinishedViewController!
var UserInfo = UserInfoStruct()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databasePath:String!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        SMSSDK.registerApp("13497b5a4a530", withSecret: "5d4aa8cc0c6a64db874b7db0ad428360")
        let dirParh = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirParh[0] as NSString
        self.databasePath = docsDir.stringByAppendingPathComponent("task.db")
        
        let screenFrame = UIScreen.mainScreen().bounds
        self.window = UIWindow(frame: screenFrame)
        self.window?.backgroundColor = .whiteColor()
        self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController = DatabaseService.sharedInstance.hasCurrentUser() ? RootTabBarController() : LogInViewController()
        return true
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

