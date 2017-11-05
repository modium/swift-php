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

    @IBAction func signInBtnPressed(_ sender: Any) {
        signIn()
    }
    
    func signIn() {
        let userEmailAddress = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        if(userEmailAddress!.isEmpty || userPassword!.isEmpty) {
            // Display alert message
            let myAlert = UIAlertController(title: "Alert", message: "Email and password must be entered.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Signing in..."
        spinningActivity.detailsLabel.text = "Please wait"
        
        let myUrl = NSURL(string: "http://localhost/swiftPHP/scripts/userSignIn.php");
        var request = URLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let postString = "userEmail=\(userEmailAddress!)&userPassword=\(userPassword!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                spinningActivity.hide(animated: true)
                
                if(error != nil) {
                    // Display alert message
                    let myAlert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    myAlert.addAction(okAction)
                    self.present(myAlert, animated: true, completion: nil)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json { // Try to unwrap JSON data
                        
                        let userId = parseJSON["userId"] as? String
                        
                        if(userId != nil) {
                            
                            // DO NOT STORE PASSWORD
                            UserDefaults.standard.set(parseJSON["userFirstName"], forKey: "userFirstName")
                            UserDefaults.standard.set(parseJSON["userLastName"], forKey: "userLastName")
                            /* This is where we store the user's Id for app use */
                            UserDefaults.standard.set(parseJSON["userId"], forKey: "userId")
                            UserDefaults.standard.synchronize() // Store user data within app for later access
                            
                            /*
                             // Take user to protected page
                             let dashboard = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
                             
                             let dashboardNav = UINavigationController(rootViewController: dashboard)
                             let appDelegate = UIApplication.sharedApplication().delegate
                             appDelegate?.window??.rootViewController = dashboardNav
                             */
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.buildNavigationDrawer()
                            
                        } else {
                            
                            // Display alert message
                            let userMessage = parseJSON["message"] as? String
                            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            myAlert.addAction(okAction)
                            self.present(myAlert, animated: true, completion: nil)
                            
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }

}

