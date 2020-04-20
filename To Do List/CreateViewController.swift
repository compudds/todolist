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
    
    func displayAlert(_ title:String, error:String) {
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var emailaddress: UITextField!
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func toggleSignUp(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "createToLogin", sender: self)
        
    }
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        if username.text == "" || password.text == "" || emailaddress.text == "" {
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            error = "Please enter all fields."
            
            displayAlert("Error In Form: ", error: error)
            
        } else {
            
            
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            user.email = emailaddress.text
            //user.channels = ["endDate"]
            
            user.signUpInBackground {
                (succeeded, signupError) -> Void in
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                if signupError == nil  {
                    // Hooray! Let them use the app now.
                    
                    print("\(PFUser.current()!) signed up")
                    
                    self.performSegue(withIdentifier: "createToHome", sender: self)
                    
                } else {
                    
                    if signupError != nil {
                        
                        error = signupError as! String
                        
                    } else {
                        
                        error = "Please try again later."
                        
                    }
                    
                    self.displayAlert("Could Not Sign Up", error: error)
                    
                }
            }
            
            let currentInstallation = PFInstallation.current()
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
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Warranty Locker requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.noInternetConnection()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
        if PFUser.current() != nil {
            
            userEmail = PFUser.current()!.email!
            print(userEmail)
            
            self.performSegue(withIdentifier: "createToHome", sender: self)
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

