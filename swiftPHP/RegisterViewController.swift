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
        let userEmail = userEmailAddressTextField.text!
        let userPassword = userPasswordTextField.text!
        let userPasswordRepeat = userPasswordRepeatTextField.text!
        let userFirstName = userFirstNameTextField.text!
        let userLastName = userLastNameTextField.text!
        
        if(userPassword != userPasswordRepeat) {
            // Display alert message
            displayAlertMessage("Passwords do not match.")
            return
        }
        
        if(userEmail.isEmpty || userPassword.isEmpty || userFirstName.isEmpty || userLastName.isEmpty) {
            // Display alert message
            displayAlertMessage("All fields must be filled.")
            return
        }
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}
