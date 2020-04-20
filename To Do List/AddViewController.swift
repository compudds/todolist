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
var productSearch = [String]()

//var imageW = UIImage()
//var imageR = UIImage()

class AddViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageWarranty = UIImagePickerController()
    var imageReceipt = UIImagePickerController()
    var imagePicked = 0
    
    var imageDataReceipt = Data()
    var imageDataWarranty = Data()
    var imageDataReceiptLength = 0
    var imageDataWarrantyLength = 0
    
    @IBOutlet var barCode: UIImageView!
    
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
    
    @IBAction func addToHome(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false

        
        performSegue(withIdentifier: "addToHome", sender: self)
    }
    
    @IBAction func addToEdit(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "addToEdit", sender: self)
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
    
    /*func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }*/
    
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
        
    }
    
    /*func setBarcode() {
        
        if (newItem.text?.isEmpty)! {
            
        } else {
            
            let imageBarcode = generateBarcode(from: newItem.text!)
            barCode.image = imageBarcode
            
        }
    }*/

    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        if newItem.text == "" {
           
            let alert = UIAlertController(title: "Product field can not be blank", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)

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
                    let rect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    
                    image1.draw(in: rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    imageDataReceipt = newImage!.pngData()!
                        
                        
                    } else {
                       
                        imageDataReceiptLength = 0
                        
                        let image3 = UIImage(named: "Default-Portrait-ns@2x.png")
                        
                        imageDataReceipt = image3!.pngData()!
                    }
                    
                //} else {
                    
                    if imageDataWarrantyLength == 1 {
                    
                    var image2 = UIImage()
                    
                    image2 = profileW.image!
                    
                    let newSize:CGSize = CGSize(width: 850,height: 850)
                    let rect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height)
                    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                    
                    image2.draw(in: rect)
                    
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                        
                    imageDataWarranty = newImage!.pngData()!
                        
                        
                    } else {

                        imageDataWarrantyLength = 0
                        
                        let image3 = UIImage(named: "Default-Portrait-ns@2x.png")
                        
                        imageDataWarranty = image3!.pngData()!
                    }
                    
                //}
            //}
            
            if imageDataWarrantyLength == 1 && imageDataReceiptLength == 1 {
            
            print(imageDataReceipt.count)
            print(imageDataWarranty.count)
            //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
            let warranty = PFObject(className:"Warranties")
            warranty["product"] = newItem.text
            warranty["productSearch"] = newItem.text?.lowercased()
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
            warranty["userId"] = PFUser.current()!.objectId!
            warranty.saveInBackground {
                (success, error) in
                if (success) {
                  
                    print("New warranty saved.")
                    
                } else {
                    
                    print(error!)
                }
                
                id = warranty.objectId!
                
                }
                
            } else {
                
                if imageDataWarrantyLength == 0 && imageDataReceiptLength == 0 {
                    
                    print(imageDataReceipt.count)
                    print(imageDataWarranty.count)
                    //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
                    let warranty = PFObject(className:"Warranties")
                    warranty["product"] = newItem.text
                    warranty["productSearch"] = newItem.text?.lowercased()
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
                    warranty["userId"] = PFUser.current()!.objectId!
                    warranty.saveInBackground {
                        (success, error) in
                        if (success) {
                            
                            print("New warranty saved.")
                            
                        } else {
                            
                            print(error!)
                        }
                        
                        id = warranty.objectId!
                        
                    }
                    
                }
                    if imageDataWarrantyLength == 1 && imageDataReceiptLength == 0 {
                        
                        print(imageDataReceipt.count)
                        print(imageDataWarranty.count)
                        //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
                        let warranty = PFObject(className:"Warranties")
                        warranty["product"] = newItem.text
                        warranty["productSearch"] = newItem.text?.lowercased()
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
                        warranty["userId"] = PFUser.current()!.objectId!
                        warranty.saveInBackground {
                            (success, error) in
                            if (success) {
                                
                                print("New warranty saved.")
                                
                            } else {
                                
                                print(error!)
                            }
                            
                            id = warranty.objectId!
                            
                        }
                    
                    
               }
                    
                    if imageDataWarrantyLength == 0 && imageDataReceiptLength == 1 {
                        
                        print(imageDataReceipt.count)
                        print(imageDataWarranty.count)
                        //if (imageDataReceiptLength == 1 && imageDataWarrantyLength == 1) {
                        let warranty = PFObject(className:"Warranties")
                        warranty["product"] = newItem.text
                        warranty["productSearch"] = newItem.text?.lowercased()
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
                        warranty["userId"] = PFUser.current()!.objectId!
                        warranty.saveInBackground {
                            (success, error) in
                            if (success) {
                                
                                print("New warranty saved.")
                                
                            } else {
                                
                                print(error!)
                            }
                            
                            id = warranty.objectId!
                            
                        }
                }

                
                
                
                
            }
            
            let alert = UIAlertController(title: "Warranty Successfully Added!", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true, completion: nil)
            
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
        
        scrollView.isScrollEnabled = true
        
        scrollView.contentSize.height = 1006
        scrollView.contentSize.width = 291
        
        //self.scrollView.delegate = self
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //setBarcode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newItem.resignFirstResponder()
        
        return true
    }

}

