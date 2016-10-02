//
//  DashboardViewController.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-01.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userFirstName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")
        let userLastName = NSUserDefaults.standardUserDefaults().stringForKey("userLastName")
        let username = userFirstName! + " " + userLastName!
        usernameLbl.text = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutBtnPressed(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let signInNav = UINavigationController(rootViewController: signInPage)
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = signInNav
        
    }
    
}
