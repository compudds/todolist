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

    @IBOutlet var imageFile: UIImageView!
    
    @IBOutlet var scrollImg: UIScrollView!
    
    var showImage = UIImage()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func shareImage(_ yourImage: UIImage) {
        let vc = UIActivityViewController(activityItems: [yourImage], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: AnyObject) {
        
        if imageFile.image == nil {
            
        } else {
            
            shareImage(imageFile.image!)
            
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
        
        performSegue(withIdentifier: "receiptImageToHome", sender: self)
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
        scrollImg.frame = CGRect(x: 15, y: 65, width: vWidth, height: vHeight)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        self.view.addSubview(scrollImg)
        
        imageFile!.layer.cornerRadius = 11.0
        imageFile!.clipsToBounds = false
        scrollImg.addSubview(imageFile!)
        
        print("Parse Image: \(parseImage)")
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageFile
    }
    
    func getImage() {
        
        print("Parse Image")
        
        let query = PFQuery(className:"Warranties")
        query.whereKey("objectId", equalTo: parseImage)
        query.findObjectsInBackground ( block: {
            (objects, error) in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) receipt image.")
                
                //if (objects as? PFObject) != nil {
                    
                    for object in objects! {
                        
                        let userImageFile = object["receipt"] as! PFFile
                        
                        if (userImageFile.name != "") {
                            
                            userImageFile.getDataInBackground ( block: {
                                (data, error) in
                                
                                if error == nil {
                                    
                                    if let parseImageFile = data {
                                        
                                        if parseImageFile.count > 0 {
                                            
                                            self.showImage = UIImage(data: parseImageFile)!
                                            
                                            self.imageFile.image = self.showImage
                                            
                                            print("UserImageFile:  \(userImageFile)")
                                            
                                        }
                                    }
                                    
                                }
                                
                                
                            })
                            
                        } else {
                            
                            let alert = UIAlertController(title: "Sorry, Receipt Image was not found.", message: "The image was never uploaded.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                                
                                alert.dismiss(animated: true, completion: nil)
                                
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    

                //}
                
            } else {
                
                print(error!)
                
                
                
            }
        })
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        noInternetConnection()
        
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            getImage()
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
                    
        } else {
            
            print("Internet connection FAILED" as AnyObject)
            
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
