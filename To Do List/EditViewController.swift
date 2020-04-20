//
//  EditViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 8/27/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
//import CoreData


var newItemEdit = String()
var productSearchEdit = String()
var modelEdit = String()
var serialEdit = String()
var boughtEdit = String()
var phoneEdit = String()
var priceEdit = String()
var purchaseDateEdit = String()
var endDateEdit = String()
var warrantyEdit = [PFFile]()
var receiptEdit = [PFFile]()

var notesEdit = String()
var parseObjectIdEdit = String()

class EditViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var notes: UITextView!
    @IBOutlet var phone: UITextField!
    @IBOutlet var newItem: UITextField!
    @IBOutlet var endDate: UITextField!
    @IBOutlet var purchaseDate: UITextField!
    @IBOutlet var bought: UITextField!
    @IBOutlet var price: UITextField!
    @IBOutlet var serial: UITextField!
    @IBOutlet var model: UITextField!
    
    @IBOutlet var profileR: UIImageView!
    @IBOutlet var profileW: UIImageView!
    
    var imageWarranty = UIImagePickerController()
    var imageReceipt = UIImagePickerController()
    var imagePicked = 0
    
    var imageDataReceiptLength = 0
    var imageDataWarrantyLength = 0
    
    var imageDataReceipt = Data()
    var imageDataWarranty = Data()
    
    var showWarrantyImage = UIImage()
    var showReceiptImage = UIImage()
    
    var photoSelected:Bool = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func editToHome(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        performSegue(withIdentifier: "editToHome", sender: self)
    }
    
    @IBAction func editToAdd(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "editToAdd", sender: self)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        newItem.text = newItemEdit
        model.text = modelEdit
        serial.text = serialEdit
        bought.text = boughtEdit
        phone.text = phoneEdit
        price.text = priceEdit
        purchaseDate.text = purchaseDateEdit
        endDate.text = endDateEdit
        notes.text = notesEdit

    }
    
    @IBAction func cameraReceipt(_ sender: AnyObject) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        imagePicked = sender.tag
        vc.delegate = self
        present(vc, animated: true)
        
        
    }
    
    @IBAction func cameraWarranty(_ sender: AnyObject) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        imagePicked = sender.tag
        vc.delegate = self
        present(vc, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
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
        
        newItemEdit = newItem.text!
        modelEdit = model.text!
        serialEdit = serial.text!
        boughtEdit = bought.text!
        phoneEdit = phone.text!
        priceEdit = price.text!
        purchaseDateEdit = purchaseDate.text!
        endDateEdit = endDate.text!
        notesEdit = notes.text!
        
        // print out the image size as a test
        print(image.size)
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        
        //for(var i=0; i <= 1; i += 1){
            
            //if i == 0 {
                
                if imageDataReceiptLength == 1 {
                    
                    var image1 = UIImage()
                    
                    image1 = profileR.image!
                    
                    let newSize:CGSize = CGSize(width: 850,height: 850)
                    let rect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    
                    image1.draw(in: rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    imageDataReceipt = (newImage?.pngData())!  //newImage!.pngData()!
                    
                } else {
                    
                    imageDataReceiptLength = 0
                    
                    let image3 = UIImage(named: "Default-Portrait-ns@2x.png")
                    
                    imageDataReceipt = (image3?.pngData())!  //image3!.pngData()!
                    
                }
                
           // } else {
                
                if imageDataWarrantyLength == 1 {
                    
                    var image2 = UIImage()
                    
                    image2 = profileW.image!
                    
                    let newSize:CGSize = CGSize(width: 850,height: 850)
                    let rect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    
                    image2.draw(in: rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    imageDataWarranty = (newImage?.pngData())!  //newImage!.pngData()!
                    
                } else {
                    
                    imageDataWarrantyLength = 0
                    
                    let image3 = UIImage(named: "Default-Portrait-ns@2x.png")
                    
                    imageDataWarranty = (image3?.pngData())!  //image3!.pngData()!
                    
                }
                
            //}
        //}
        
        if(imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
        let query = PFQuery(className:"Warranties")
            query.getObjectInBackground(withId: parseObjectIdEdit) {
            (object, error) -> Void in
            if error != nil {
                print(error!)
            } else if let object = object {
                object["product"] = self.newItem.text
                object["productSearch"] = self.newItem.text?.lowercased()
                object["model"] = self.model.text
                object["serial"] = self.serial.text
                object["bought"] = self.bought.text
                object["phone"] = self.phone.text
                object["price"] = self.price.text
                object["purchaseDate"] = self.purchaseDate.text
                object["endDate"] = self.endDate.text
                object["notes"] = self.notes.text
                object["receipt"] = PFFile(name:"receipt.png", data:self.imageDataReceipt)
                object["warranty"] = PFFile(name:"warranty.png", data:self.imageDataWarranty)
                object.saveInBackground()
            }
            
            }
        
        }
        
        if(imageDataReceiptLength == 1 && imageDataWarrantyLength == 0) {
                let query = PFQuery(className:"Warranties")
                query.getObjectInBackground(withId: parseObjectIdEdit) {
                    (object, error) -> Void in
                    if error != nil {
                        print(error!)
                    } else if let object = object {
                        object["product"] = self.newItem.text
                        object["productSearch"] = self.newItem.text?.lowercased()
                        object["model"] = self.model.text
                        object["serial"] = self.serial.text
                        object["bought"] = self.bought.text
                        object["phone"] = self.phone.text
                        object["price"] = self.price.text
                        object["purchaseDate"] = self.purchaseDate.text
                        object["endDate"] = self.endDate.text
                        object["notes"] = self.notes.text
                        object["receipt"] = PFFile(name:"receipt.png", data:self.imageDataReceipt)
                        //object["warranty"] = PFFile(name:"warranty.png", data:self.imageDataWarranty)
                        object.saveInBackground()
                    }
                    }
        }
        
        if(imageDataReceiptLength == 0 && imageDataWarrantyLength == 1) {
                let query = PFQuery(className:"Warranties")
                query.getObjectInBackground(withId: parseObjectIdEdit) {
                    (object, error) -> Void in
                    if error != nil {
                        print(error!)
                    } else if let object = object {
                        object["product"] = self.newItem.text
                        object["productSearch"] = self.newItem.text?.lowercased()
                        object["model"] = self.model.text
                        object["serial"] = self.serial.text
                        object["bought"] = self.bought.text
                        object["phone"] = self.phone.text
                        object["price"] = self.price.text
                        object["purchaseDate"] = self.purchaseDate.text
                        object["endDate"] = self.endDate.text
                        object["notes"] = self.notes.text
                        //object["receipt"] = PFFile(name:"receipt.png", data:self.imageDataReceipt)
                        object["warranty"] = PFFile(name:"warranty.png", data:self.imageDataWarranty)
                        object.saveInBackground()
                    }
                }
            }
        
        if(imageDataReceiptLength == 0 && imageDataWarrantyLength == 0) {
            let query = PFQuery(className:"Warranties")
            query.getObjectInBackground(withId: parseObjectIdEdit) {
                (object, error) -> Void in
                if error != nil {
                    print(error!)
                } else if let object = object {
                    object["product"] = self.newItem.text
                    object["productSearch"] = self.newItem.text?.lowercased()
                    object["model"] = self.model.text
                    object["serial"] = self.serial.text
                    object["bought"] = self.bought.text
                    object["phone"] = self.phone.text
                    object["price"] = self.price.text
                    object["purchaseDate"] = self.purchaseDate.text
                    object["endDate"] = self.endDate.text
                    object["notes"] = self.notes.text
                    //object["receipt"] = PFFile(name:"receipt.png", data:self.imageDataReceipt)
                    //object["warranty"] = PFFile(name:"warranty.png", data:self.imageDataWarranty)
                    object.saveInBackground()
                }
            }
        }
        
        let alert = UIAlertController(title: "Update Complete!", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            self.performSegue(withIdentifier: "editToHome", sender: self)
            
            alert.dismiss(animated: true, completion: nil)
       
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        imagePicked = 0
        profileR.alpha = 0
        profileW.alpha = 0
        imageDataReceiptLength = 0
        imageDataWarrantyLength = 0
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 1006  //1780
        scrollView.contentSize.width = 251
        
        //self.scrollView.delegate = self
        
        getWarrantyImage()
        getReceiptImage()
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            print(parseObjectIdEdit)
            
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
               
        newItem.text = newItemEdit
        model.text = modelEdit
        serial.text = serialEdit
        bought.text = boughtEdit
        phone.text = phoneEdit
        price.text = priceEdit
        purchaseDate.text = purchaseDateEdit
        endDate.text = endDateEdit
        notes.text = notesEdit
        //getWarrantyImage()
        //getReceiptImage()
        
        noInternetConnection()
    }
    
    func getWarrantyImage() {
        
        
        let query = PFQuery(className:"Warranties")
        query.whereKey("objectId", equalTo: parseImage)
        query.findObjectsInBackground {
            (objects, error) in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) warranty image.")
                
                //if let objects = objects {
                for object in objects! {
                    
                    let userImageFile = object["warranty"] as! PFFile  //anotherPhoto["imageFile"] as PFFile
                    
                    if (userImageFile.name != "") {
                        
                        userImageFile.getDataInBackground {
                            (imageData, error) in
                            if error == nil {
                                if let imageData = imageData {
                                    
                                    if imageData.count > 0 {
                                        
                                        self.showWarrantyImage = UIImage(data:imageData)!
                                        self.profileW.image = self.showWarrantyImage
                                        
                                    }
                                }
                                
                            }
                            
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func getReceiptImage() {
        
        
        let query = PFQuery(className:"Warranties")
        query.whereKey("objectId", equalTo: parseImage)
        query.findObjectsInBackground {
            (objects, error) in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) warranty image.")
                
                //if let objects = objects {
                for object in objects! {
                    
                    let userImageFile = object["receipt"] as! PFFile  //anotherPhoto["imageFile"] as PFFile
                    
                    if (userImageFile.name != "") {
                        
                        userImageFile.getDataInBackground {
                            (imageData, error) in
                            if error == nil {
                                if let imageData = imageData {
                                    
                                    if imageData.count > 0 {
                                        
                                        self.showReceiptImage = UIImage(data:imageData)!
                                        self.profileR.image = self.showReceiptImage
                                        
                                    }
                                }
                                
                            }
                            
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newItem.resignFirstResponder()
        
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
