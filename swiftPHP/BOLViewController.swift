//
//  BOLViewController.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-02.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

class BOLViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sidebarBtnPressed(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
}
