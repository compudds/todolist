//
//  WarrantyImageViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 9/1/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

class WarrantyImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var image: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var showImage = UIImage()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func print(sender: AnyObject) {
        
        func shareImage(yourImage: UIImage) {
        
            let vc = UIActivityViewController(activityItems: [yourImage], applicationActivities: [])
            presentViewController(vc, animated: true, completion: nil)
        }
        
        shareImage(showImage)
        
        
    }
    @IBAction func backBtn(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        performSegueWithIdentifier("warrantyImageToHome", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 531
        scrollView.contentSize.width = 353
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRectMake(15, 60, vWidth, vHeight)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        self.view.addSubview(scrollImg)
        
        image!.layer.cornerRadius = 11.0
        image!.clipsToBounds = false
        scrollImg.addSubview(image!)
        
        // Do any additional setup after loading the view.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    func getImage() {
        
        //var imageShow = UIImage()
        //let imageData = UIImagePNGRepresentation(imageShow)
        //let imageFile = PFFile(name:"warranty.png", data:imageData)
        
        let query = PFQuery(className:"Warranties")
        query.whereKey("objectId", equalTo: parseImage)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.print("Successfully retrieved \(objects!.count) warranty image.")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        let userImageFile = object["warranty"] as! PFFile  //anotherPhoto["imageFile"] as PFFile
                       
                        userImageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    
                                    if imageData.length > 0 {
        
                                        self.showImage = UIImage(data:imageData)!
                                        self.image.image = self.showImage
                                        
                                    }  else {
                                        
                                        //self.showImage = UIImage(named:"icon.png")!
                                        //self.image.image = self.showImage
                                        
                                    }
                                   
                                }
                                
                            }

                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                self.print(error!)
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            getImage()
            
            
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
