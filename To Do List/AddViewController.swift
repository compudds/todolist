//
//  SecondViewController.swift
//  Warranty Wallet
//  Created by Eric Cook on 10/23/14.
//  Copyright (c) 2014 Better Search, LLC. All rights reserved.
//

import UIKit
//import CoreData
import Parse

var id = String()
var newItemItem = [String]()
var modelItem = [String]()
var serialItem = [String]()
var boughtItem = [String]()
var priceItem = [String]()
var phoneItem = [String]()
var purchaseDateItem = [String]()
var endDateItem = [String]()
var warrantyItem = [PFFile]()
var receiptItem = [PFFile]()
var notesItem = [String]()

//var imageW = UIImage()
//var imageR = UIImage()

class AddViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageWarranty = UIImagePickerController()
    var imageReceipt = UIImagePickerController()
    var imagePicked = 0
    
    var imageDataReceipt = NSData()
    var imageDataWarranty = NSData()
    var imageDataReceiptLength = 0
    var imageDataWarrantyLength = 0
    
    var photoSelected:Bool = false

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var notes: UITextView!
    @IBOutlet var newItem: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var endDate: UITextField!
    @IBOutlet var purchaseDate: UITextField!
    @IBOutlet var bought: UITextField!
    @IBOutlet var price: UITextField!
    @IBOutlet var serial: UITextField!
    @IBOutlet var model: UITextField!
    
    @IBOutlet var profileR: UIImageView!
    @IBOutlet var profileW: UIImageView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func addToHome(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        
        performSegueWithIdentifier("addToHome", sender: self)
    }
    
    @IBAction func addToEdit(sender: AnyObject) {
        
        performSegueWithIdentifier("addToEdit", sender: self)
    }
    
    @IBAction func cameraReceipt(sender: AnyObject) {
        
        imageReceipt.delegate = self
        imageReceipt.sourceType = UIImagePickerControllerSourceType.Camera
        imageReceipt.allowsEditing = false
        imagePicked = sender.tag
        self.presentViewController(imageReceipt, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cameraWarranty(sender: AnyObject) {
        
        imageWarranty.delegate = self
        imageWarranty.sourceType = UIImagePickerControllerSourceType.Camera
        imageWarranty.allowsEditing = false
        imagePicked = sender.tag
        self.presentViewController(imageWarranty, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        print("Image selected")
        
        if imagePicked == 1 {
            
            profileR.image = image
            profileR.alpha = 1
            imageDataReceiptLength = 1
            
        } else if imagePicked == 2 {
            
            profileW.image = image
            profileW.alpha = 1
            imageDataWarrantyLength = 1
        }
        
        photoSelected = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        if newItem.text == "" {
           
            let alert = UIAlertController(title: "Product field can not be blank", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            
            /*var stringts = phone.text as NSMutableString
            
            if(phone.text.isEmpty){
                
            } else {
                
            stringts.insertString("(", atIndex: 0)
            stringts.insertString(")", atIndex: 4)
            stringts.insertString(" ", atIndex: 5)
            stringts.insertString("-", atIndex: 9)
            phone.text = stringts as String
            
            }*/
            //for(var i=0; i <= 1; i += 1){
                
                //if i == 0 {
                    
                    if imageDataReceiptLength == 1 {
                    
                    var image1 = UIImage()
                    
                    image1 = profileR.image!
                    
                    let newSize:CGSize = CGSize(width: 850,height: 850)
                    let rect = CGRectMake(0,0, newSize.width, newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    
                    image1.drawInRect(rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    imageDataReceipt = UIImagePNGRepresentation(newImage)!
                        
                        
                    } else {
                       
                        imageDataReceiptLength == 0
                        
                        let image3 = UIImage(named: "Default-Portrait-ns@2x.png")
                        
                        imageDataReceipt = UIImagePNGRepresentation(image3!)!
                    }
                    
                //} else {
                    
                    if imageDataWarrantyLength == 1 {
                    
                    var image2 = UIImage()
                    
                    image2 = profileW.image!
                    
                    let newSize:CGSize = CGSize(width: 850,height: 850)
                    let rect = CGRectMake(0,0, newSize.width, newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    
                    image2.drawInRect(rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                        
                    imageDataWarranty = UIImagePNGRepresentation(newImage)!
                        
                        
                    } else {

                        imageDataWarrantyLength == 0
                        
                        let image3 = UIImage(named: "Default-Portrait-ns@2x.png")
                        
                        imageDataWarranty = UIImagePNGRepresentation(image3!)!
                    }
                    
                //}
            //}
            
            if imageDataWarrantyLength == 1 && imageDataReceiptLength == 1 {
            
            print(imageDataReceipt.length)
            print(imageDataWarranty.length)
            //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
            let warranty = PFObject(className:"Warranties")
            warranty["product"] = newItem.text
            warranty["model"] = model.text
            warranty["serial"] = serial.text
            warranty["price"] = price.text
            warranty["bought"] = bought.text
            warranty["phone"] = phone.text
            warranty["purchaseDate"] = purchaseDate.text
            warranty["endDate"] = endDate.text
            warranty["notes"] = notes.text
            warranty["receipt"] = PFFile(name:"receipt.png", data:imageDataReceipt)
            warranty["warranty"] = PFFile(name:"warranty.png", data:imageDataWarranty)
            warranty["userId"] = PFUser.currentUser()!.objectId!
            warranty.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                  
                    print("New warranty saved.")
                    
                } else {
                    
                    print(error)
                }
                
                id = warranty.objectId!
                
                }
                
            } else {
                
                if imageDataWarrantyLength == 0 && imageDataReceiptLength == 0 {
                    
                    print(imageDataReceipt.length)
                    print(imageDataWarranty.length)
                    //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
                    let warranty = PFObject(className:"Warranties")
                    warranty["product"] = newItem.text
                    warranty["model"] = model.text
                    warranty["serial"] = serial.text
                    warranty["price"] = price.text
                    warranty["bought"] = bought.text
                    warranty["phone"] = phone.text
                    warranty["purchaseDate"] = purchaseDate.text
                    warranty["endDate"] = endDate.text
                    warranty["notes"] = notes.text
                    warranty["receipt"] = PFFile(name:"receipt.png", data:imageDataReceipt)
                    warranty["warranty"] = PFFile(name:"warranty.png", data:imageDataWarranty)
                    warranty["userId"] = PFUser.currentUser()!.objectId!
                    warranty.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            
                            print("New warranty saved.")
                            
                        } else {
                            
                            print(error)
                        }
                        
                        id = warranty.objectId!
                        
                    }
                    
                }
                    if imageDataWarrantyLength == 1 && imageDataReceiptLength == 0 {
                        
                        print(imageDataReceipt.length)
                        print(imageDataWarranty.length)
                        //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
                        let warranty = PFObject(className:"Warranties")
                        warranty["product"] = newItem.text
                        warranty["model"] = model.text
                        warranty["serial"] = serial.text
                        warranty["price"] = price.text
                        warranty["bought"] = bought.text
                        warranty["phone"] = phone.text
                        warranty["purchaseDate"] = purchaseDate.text
                        warranty["endDate"] = endDate.text
                        warranty["notes"] = notes.text
                        warranty["receipt"] = PFFile(name:"receipt.png", data:imageDataReceipt)
                        warranty["warranty"] = PFFile(name:"warranty.png", data:imageDataWarranty)
                        warranty["userId"] = PFUser.currentUser()!.objectId!
                        warranty.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                
                                print("New warranty saved.")
                                
                            } else {
                                
                                print(error)
                            }
                            
                            id = warranty.objectId!
                            
                        }
                    
                    
               }
                    
                    if imageDataWarrantyLength == 0 && imageDataReceiptLength == 1 {
                        
                        print(imageDataReceipt.length)
                        print(imageDataWarranty.length)
                        //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
                        let warranty = PFObject(className:"Warranties")
                        warranty["product"] = newItem.text
                        warranty["model"] = model.text
                        warranty["serial"] = serial.text
                        warranty["price"] = price.text
                        warranty["bought"] = bought.text
                        warranty["phone"] = phone.text
                        warranty["purchaseDate"] = purchaseDate.text
                        warranty["endDate"] = endDate.text
                        warranty["notes"] = notes.text
                        warranty["receipt"] = PFFile(name:"receipt.png", data:imageDataReceipt)
                        warranty["warranty"] = PFFile(name:"warranty.png", data:imageDataWarranty)
                        warranty["userId"] = PFUser.currentUser()!.objectId!
                        warranty.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                
                                print("New warranty saved.")
                                
                            } else {
                                
                                print(error)
                            }
                            
                            id = warranty.objectId!
                            
                        }
                }

                
                
                
                
            }
            
            let alert = UIAlertController(title: "Warranty Successfully Added!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            newItem.text = ""
            model.text = ""
            serial.text = ""
            bought.text = ""
            price.text = ""
            purchaseDate.text = ""
            endDate.text = ""
            phone.text = ""
            notes.text = ""
            imagePicked = 0
            profileR.alpha = 0
            profileW.alpha = 0
            imageDataReceiptLength = 0
            imageDataWarrantyLength = 0

            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.contentSize.height = 1006
        scrollView.contentSize.width = 291
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
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newItem.resignFirstResponder()
    
        return true
    }

}

