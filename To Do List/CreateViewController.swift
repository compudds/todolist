//
//  CreateViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 8/30/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var signupActive = Bool()
var userEmail = String()
var userText = String()

class CreateViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var emailaddress: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        
        self.performSegueWithIdentifier("createToLogin", sender: self)
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if username.text == "" || password.text == "" || emailaddress.text == "" {
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            error = "Please enter all fields."
            
            displayAlert("Error In Form: ", error: error)
            
        } else {
            
            
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            user.email = emailaddress.text
            //user.channels = ["endDate"]
            
            user.signUpInBackgroundWithBlock {
                (succeeded, signupError) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signupError == nil  {
                    // Hooray! Let them use the app now.
                    
                    print("\(PFUser.currentUser()!.username) signed up")
                    
                    self.performSegueWithIdentifier("createToHome", sender: self)
                    
                } else {
                    
                    if let errorString = signupError!.userInfo["error"] as? NSString {
                        
                        error = errorString as String
                        
                    } else {
                        
                        error = "Please try again later."
                        
                    }
                    
                    self.displayAlert("Could Not Sign Up", error: error)
                    
                }
            }
            
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.addUniqueObject("expireDate", forKey: "channels")
            currentInstallation.saveInBackground()
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //clean = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            
        } else {
            
            print("Internet connection FAILED")
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Warranty Locker requires an internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .Default, handler: { action in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.noInternetConnection()
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
    }

    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
        
        if PFUser.currentUser() != nil {
            
            userEmail = PFUser.currentUser()!.email!
            print(userEmail)
            
            self.performSegueWithIdentifier("createToHome", sender: self)
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // username.resignFirstResponder()
        return true
    }
    
    /*override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }*/
    
}

