//
//  LogInViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 8/30/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
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
    
    @IBOutlet var alreadyRegistered: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var signUpLabel: UILabel!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    @IBAction func create(_ sender: AnyObject) {
        
        
        self.performSegue(withIdentifier: "loginToCreate", sender: self)
        
        
    }
    
    
    @IBOutlet var emailPasswordReset: UITextField!
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        
        self.emailPasswordReset.alpha = 1
        self.loginButton.setTitle("Send", for: UIControl.State())
        self.password.alpha = 0
        self.username.alpha = 0
        
    }
    
    @IBAction func loginn(_ sender: AnyObject) {
        
        var error = ""
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        if self.emailPasswordReset.alpha == 0 {
            
            if username.text == "" || password.text == "" {
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                error = "Please enter all fields."
                
                displayAlert("Error In Form: ", error: error)
                
            } else {
                
                
                PFUser.logInWithUsername(inBackground: username.text!, password:password.text!) {
                    (user, signupError) -> Void in
                    
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    if user != nil {
                        
                        print("\(PFUser.current()!) is logged in")
                        userEmail = PFUser.current()!.email!
                        
                        currentLoginState = "authorized"
                        
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                        
                    } else {
                        
                        
                        if signupError != nil {
                            
                            error = signupError as! String
                            
                        } else {
                            
                            error = "Please try again later."
                            
                        }
                        
                        self.displayAlert("Could Not Log In", error: error)
                        
                    }
                    
                    signupActive = true
                    
                }
                
            }
            
        } else {
            
            if self.emailPasswordReset.text != "" {
                
                PFUser.requestPasswordResetForEmail(inBackground: self.emailPasswordReset.text!)
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                
                self.emailPasswordReset.alpha = 0
                self.password.alpha = 1
                self.username.alpha = 1
                self.loginButton.setTitle("Log In", for: UIControl.State())
                
            } else {
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                
                let alert = UIAlertController(title: "Enter email address!", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            if(PFUser.current() != nil) {
                
                print(PFUser.current()!)
                
            }
            
            
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
        
        if (PFUser.current() != nil ) {
            
            userEmail = PFUser.current()!.email!
            
            print(userEmail)
            
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        
        } 
            
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // username.resignFirstResponder()
        return true
    }
    
}

