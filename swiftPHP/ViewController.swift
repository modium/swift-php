//
//  ViewController.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-01.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInBtnPressed(sender: AnyObject) {
        let userEmailAddress = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        if(userEmailAddress!.isEmpty || userPassword!.isEmpty) {
            // Display alert message
            let myAlert = UIAlertController(title: "Alert", message: "Email and password must be entered.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.label.text = "Signing in..."
        spinningActivity.detailsLabel.text = "Please wait"
        
        let myUrl = NSURL(string: "http://localhost/swiftPHP/scripts/userSignIn.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmailAddress!)&userPassword=\(userPassword!)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in

            dispatch_async(dispatch_get_main_queue()) {
            
                spinningActivity.hideAnimated(true)                
                
                if(error != nil) {
                    // Display alert message
                    let myAlert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    return
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    if let parseJSON = json { // Try to unwrap JSON data
                        
                        let userId = parseJSON["userId"] as? String
                        
                        if(userId != nil) {
                            
                            // DO NOT STORE PASSWORD
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userFirstName"], forKey: "userFirstName")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userLastName"], forKey: "userLastName")
                            /* This is where we store the user's Id for app use */
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userId"], forKey: "userId")
                            NSUserDefaults.standardUserDefaults().synchronize() // Store user data within app for later access
                            
                            /*
                            // Take user to protected page
                            let dashboard = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
                            
                            let dashboardNav = UINavigationController(rootViewController: dashboard)
                            let appDelegate = UIApplication.sharedApplication().delegate
                            appDelegate?.window??.rootViewController = dashboardNav
                            */
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.buildNavigationDrawer()
 
                        } else {
                            
                            // Display alert message
                            let userMessage = parseJSON["message"] as? String
                            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated: true, completion: nil)
                            
                        }
                        
                    }
                } catch {
                    print(error)
                }
                
            }
            
        }).resume()
        
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}

