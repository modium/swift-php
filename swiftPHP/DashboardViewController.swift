//
//  DashboardViewController.swift
//  swiftPHP
//
//  Created by Jaf Crisologo on 2016-10-01.
//  Copyright © 2016 Modium Design. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userFirstName = UserDefaults.standard.string(forKey: "userFirstName")
        let userLastName = UserDefaults.standard.string(forKey: "userLastName")
        let username = userFirstName! + " " + userLastName!
        usernameLbl.text = username
        
        // Check if profile image is set
        if(profilePhotoImageView.image == nil) {
            let userId = UserDefaults.standard.string(forKey: "userId")
            let imageUrl = NSURL(string:"http://localhost/swiftPHP/photos/\(userId!)/user-profile.jpg") // Concatenate user id to image path
            
            // Dispatch an asynchronous background thread
            DispatchQueue.global(qos: .background).async {
                let imageData = NSData(contentsOf: imageUrl! as URL)
                
                if(imageData != nil) {
                    // Communicate back to the UI
                    DispatchQueue.main.async {
                        self.profilePhotoImageView.image = UIImage(data: imageData! as Data)
                    }
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPhotoBtnPressed(sender: AnyObject) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)

        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Loading image..."
        spinningActivity.detailsLabel.text = "Please wait"
        
        imgUploadRequest()
    }

    func imgUploadRequest() {
        let myUrl = NSURL(string: "http://localhost/swiftPHP/scripts/imageUpload.php");
        var request = URLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let userId:String? = UserDefaults.standard.string(forKey: "userId")
        
        let param = [
            "userId" : userId!
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if(imageData==nil)  { return; } // If image is empty, do not upload to server

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData as! NSData, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                DispatchQueue.main.async() {
                    if let parseJSON = json {
                        // let userId = parseJSON["userId"] as? String
                        
                        // Display an alert message
                        let userMessage = parseJSON["message"] as? String
                        self.displayAlertMessage(userMessage: userMessage!)
                    } else {
                        // Display an alert message
                        let userMessage = "Could not upload image at this time."
                        self.displayAlertMessage(userMessage: userMessage)
                    }
                }
            } catch
            {
                print(error)
            }
            
        }
        task.resume()
    }
  
    @IBAction func sidebarBtnPressed(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    // Separate each HTTP request with this
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
        
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData!, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
//    @IBAction func logoutBtnPressed(sender: AnyObject) {
//        
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
//        NSUserDefaults.standardUserDefaults().synchronize()
//        
//        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
//        let signInNav = UINavigationController(rootViewController: signInPage)
//        let appDelegate = UIApplication.sharedApplication().delegate
//        appDelegate?.window??.rootViewController = signInNav
//        
//    }
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
