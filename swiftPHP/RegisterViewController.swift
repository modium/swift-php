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
        dismiss(animated: true, completion: nil)
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
            displayAlertMessage(userMessage: "Passwords do not match")
            return
        }
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty)
        {
            // Display an alert message
            displayAlertMessage(userMessage: "All fields are required to fill in")
            return
        }
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Registering..."
        spinningActivity.detailsLabel.text = "Please wait"
        
        // Send HTTP POST
        let myUrl = NSURL(string: "http://localhost/swiftPHP/scripts/registerUser.php");
        var request = URLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let postString = "userEmail=\(userEmail!)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPassword=\(userPassword!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                spinningActivity.hide(animated: true) // Hide spinner by this point
                
                if error != nil {
                    self.displayAlertMessage(userMessage: error!.localizedDescription)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        let userId = parseJSON["userId"] as? String
                        
                        if( userId != nil)
                        {
                            let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(action) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            myAlert.addAction(okAction);
                            self.present(myAlert, animated: true, completion: nil)
                        } else {
                            let errorMessage = parseJSON["message"] as? String
                            if(errorMessage != nil){
                                self.displayAlertMessage(userMessage: errorMessage!)
                            }
                            
                        }
                        
                    }
                } catch{
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
        self.present(myAlert, animated: true, completion: nil)
    }
    
}
