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
    
   // @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var scrollImg: UIScrollView!
    
    var showImage = UIImage()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func shareImage(_ yourImage: UIImage) {
        
        let vc = UIActivityViewController(activityItems: [yourImage], applicationActivities: [])
        
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func sendBtn(_ sender: AnyObject) {
        
        if image.image == nil {
            
        } else {
            
            shareImage(image.image!)
            
        }

        
    }
    @IBAction func backBtn(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
       
        
        parseImage = ""
        
        performSegue(withIdentifier: "warrantyImageToHome", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
         activityIndicator.center = self.view.center
         activityIndicator.hidesWhenStopped = true
         activityIndicator.style = UIActivityIndicatorView.Style.large
         self.view.addSubview(activityIndicator)
         activityIndicator.startAnimating()
         self.view.isUserInteractionEnabled = false
        
        
        
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        //let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 15, y: 60, width: vWidth, height: vHeight)
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
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    func getImage() {
        
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
        
                                        self.showImage = UIImage(data:imageData)!
                                        self.image.image = self.showImage
                                        
                                    }
                                }
                                
                            }

                            
                        }
                        
                        } else {
                                
                                let alert = UIAlertController(title: "Sorry, Warranty Image was not found.", message: "The image was never uploaded.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                                    
                                    alert.dismiss(animated: true, completion: nil)
                                    
                                    
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            
                                
                            }
                        
                    }

                    
                //}
                
            } else {
                
                print(error!)
                
                let alert = UIAlertController(title: "Sorry, Warranty Image was not found.", message: "The image was never uploaded.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
    }

    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            //print(userEmail)
            
            getImage()
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
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
