//
//  SidebarViewController.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-02.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var sidebarItems:[String] = ["Dashboard", "BOL", "Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sidebarItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("sidebarCell", forIndexPath: indexPath) /*as! UITableViewCell*/
        
        myCell.textLabel?.text = sidebarItems[indexPath.row]
        
        return myCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // This is called when a user taps on a row in the UITableView
        switch(indexPath.row) {
            case 0:
                let dashboardViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
                let dashboardNav = UINavigationController(rootViewController: dashboardViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.drawerContainer!.centerViewController = dashboardNav
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break
            case 1:
                let bolViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BOLViewController") as! BOLViewController
                let bolNav = UINavigationController(rootViewController: bolViewController)
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.drawerContainer!.centerViewController = bolNav
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                break
            case 2:
                NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                let signInNav = UINavigationController(rootViewController: signInPage)
                let appDelegate = UIApplication.sharedApplication().delegate
                appDelegate?.window??.rootViewController = signInNav
                break
            default:
                print("Do nothing")
        }
    }
    
}
