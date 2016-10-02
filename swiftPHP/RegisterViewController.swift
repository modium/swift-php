//
//  RegisterViewController.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-01.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var accountTypeTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyPhoneTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerBtnPressed(sender: AnyObject) {


        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        
        if( userPassword != userPasswordRepeat)
        {
            // Display alert message
            displayAlertMessage("Passwords do not match")
            return
        }
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty)
        {
            // Display an alert message
            displayAlertMessage("All fields are required to fill in")
            return
        }
        
        // Send HTTP POST
        
        let myUrl = NSURL(string: "http://localhost/swiftPHP/scripts/registerUser.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmail!)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPassword=\(userPassword!)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            dispatch_async(dispatch_get_main_queue()) {

                if error != nil {
                    self.displayAlertMessage(error!.localizedDescription)
                    return
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        let userId = parseJSON["userId"] as? String
                        
                        if( userId != nil)
                        {
                            let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.Alert);
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            
                            myAlert.addAction(okAction);
                            self.presentViewController(myAlert, animated: true, completion: nil)
                        } else {
                            let errorMessage = parseJSON["message"] as? String
                            if(errorMessage != nil){
                                self.displayAlertMessage(errorMessage!)
                            }
                            
                        }
                        
                    }
                } catch{
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
