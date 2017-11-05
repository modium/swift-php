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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sidebarItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "sidebarCell", for: indexPath as IndexPath) /*as! UITableViewCell*/
        
        myCell.textLabel?.text = sidebarItems[indexPath.row]
        
        return myCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // This is called when a user taps on a row in the UITableView
        switch(indexPath.row) {
            case 0:
                let dashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                let dashboardNav = UINavigationController(rootViewController: dashboardViewController)
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.drawerContainer!.centerViewController = dashboardNav
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                break
            case 1:
                let bolViewController = self.storyboard?.instantiateViewController(withIdentifier: "BOLViewController") as! BOLViewController
                let bolNav = UINavigationController(rootViewController: bolViewController)
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.drawerContainer!.centerViewController = bolNav
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                break
            case 2:
                UserDefaults.standard.removeObject(forKey: "userFirstName")
                UserDefaults.standard.removeObject(forKey: "userLastName")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.synchronize()
                
                let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let signInNav = UINavigationController(rootViewController: signInPage)
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = signInNav
                break
            default:
                print("Do nothing")
        }
    }
    
}
