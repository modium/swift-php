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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let userFirstName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")
        let userLastName = NSUserDefaults.standardUserDefaults().stringForKey("userLastName")
        let username = userFirstName! + " " + userLastName!
        usernameLbl.text = username
        
        // Check if profile image is set
        if(profilePhotoImageView.image == nil) {
            let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
            let imageUrl = NSURL(string:"http://localhost/swiftPHP/photos/\(userId!)/user-profile.jpg") // Concatenate user id to image path
            
            // Dispatch an asynchronous background thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let imageData = NSData(contentsOfURL: imageUrl!)
                
                if(imageData != nil) {
                    // Communicate back to the UI
                    dispatch_async(dispatch_get_main_queue(), {
                        self.profilePhotoImageView.image = UIImage(data: imageData!)
                    })
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
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)

        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.label.text = "Loading image..."
        spinningActivity.detailsLabel.text = "Please wait"
        
        imgUploadRequest()
    }

    func imgUploadRequest() {
        let myUrl = NSURL(string: "http://localhost/swiftPHP/scripts/imageUpload.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let userId:String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        let param = [
            "userId" : userId!
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if(imageData==nil)  { return; } // If image is empty, do not upload to server

        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                dispatch_async(dispatch_get_main_queue()) {
                    if let parseJSON = json {
                        // let userId = parseJSON["userId"] as? String
                        
                        // Display an alert message
                        let userMessage = parseJSON["message"] as? String
                        self.displayAlertMessage(userMessage!)
                    } else {
                        // Display an alert message
                        let userMessage = "Could not upload image at this time."
                        self.displayAlertMessage(userMessage)
                    }
                }
            } catch
            {
                print(error)
            }
            
        }).resume()
        
    }
  
    @IBAction func sidebarBtnPressed(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    // Separate each HTTP request with this
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
        
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData!, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
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
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
