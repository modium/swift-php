//
//  AppDelegate.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-01.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerContainer:MMDrawerController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        if(userId != nil) {
            // If user is signed in, take them to dashboard
//            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainPage = mainStoryboard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
//            let mainPageNav = UINavigationController(rootViewController: mainPage)
//            self.window?.rootViewController = mainPageNav
            
            buildNavigationDrawer()
            
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func buildNavigationDrawer() {
        // Navigate to the dashboard
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate view controllers
        let dashboard:DashboardViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
        let sidebar:SidebarViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SidebarViewController") as! SidebarViewController
        
        let dashboardNav = UINavigationController(rootViewController: dashboard)
        let sidebarNav = UINavigationController(rootViewController: sidebar)
        
        drawerContainer = MMDrawerController(centerViewController: dashboardNav, leftDrawerViewController: sidebarNav)
        
        drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        window?.rootViewController = drawerContainer
    }
    
}

