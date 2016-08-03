//
//  ReceiptImageViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 9/1/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

class ReceiptImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var image: UIImageView!
    
    @IBOutlet var scrollImg: UIScrollView!
    
    var showImage = UIImage()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func shareImage(yourImage: UIImage) {
        let vc = UIActivityViewController(activityItems: [yourImage], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func print(sender: AnyObject) {
        
        if image.image == nil {
            
        } else {
            
            shareImage(image.image!)
            
        }
        
    }

    @IBAction func backBtn(sender: AnyObject) {
    
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        parseImage = ""
        
        performSegueWithIdentifier("receiptImageToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.contentSize.height = 450
        //scrollView.contentSize.width = 300
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        //let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRectMake(15, 65, vWidth, vHeight)
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
        
        print("Parse Image: \(parseImage)")
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    override func viewDidAppear(animated: Bool) {
        
        noInternetConnection()
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            //print(userEmail)
            
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
    


    func getImage() {
        //print("Parse Image: \(parseImage)")
        let query = PFQuery(className:"Warranties")
        query.whereKey("objectId", equalTo: parseImage)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.print("Successfully retrieved \(objects!.count) receipt image.")
                
                //if let objects = objects {
                    
                    for object in objects! {
                        
                        let userImageFile = object["receipt"] as! PFFile
                        self.print(userImageFile)
                        
                        if (userImageFile.name != "") {
                            userImageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        
                                        if imageData.length > 0 {
                                            
                                            self.showImage = UIImage(data:imageData)!
                                            self.image.image = self.showImage
                                            
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                            
                        } else {
                            
                            let alert = UIAlertController(title: "Sorry, Receipt Image was not found.", message: "The image was never uploaded.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
                                
                                alert.dismissViewControllerAnimated(true, completion: nil)
                                
                                
                            }))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    

                //}
                
            } else {
                
                self.print(error!)
                
                
                
            }
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
