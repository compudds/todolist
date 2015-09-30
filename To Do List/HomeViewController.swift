//
//  FirstViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 10/23/14.
//  Copyright (c) 2014 Better Search, LLC. All rights reserved.
//

import UIKit
//import CoreData
import Parse

var array:[String] = [String]()

var parseObjectId = [String]()

var parseImage = String()

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet  var tableView:UITableView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var logOut: UIButton!
    
    @IBAction func receiptImage(sender: AnyObject) {
        
        performSegueWithIdentifier("homeToReceiptImage", sender: self)

    }
    
    @IBAction func warrantyImage(sender: AnyObject) {
        
        performSegueWithIdentifier("homeToWarrantyImage", sender: self)
    }
    
    @IBAction func homeToAdd(sender: AnyObject) {
        
        performSegueWithIdentifier("homeToAdd", sender: self)
    }
    
    @IBOutlet var editBtn: UIBarButtonItem!
    
    @IBAction func homeToEdit(sender: AnyObject) {
        
        performSegueWithIdentifier("homeToEdit", sender: self)
    }
    @IBAction func logOutBtn(sender: AnyObject) {
        
        newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        parseObjectId = []
        
        PFUser.logOut()
        
        performSegueWithIdentifier("homeToLogin", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newItemItem.count
    }
    
    let reuseIdentifier = "Cell1"
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell!
        
        cell!.textLabel!.numberOfLines = 0
        
        cell!.textLabel!.font = UIFont.systemFontOfSize(18)
        
        cell!.textLabel!.text = " Product: \(newItemItem[indexPath.row]) \r Model #: \(modelItem[indexPath.row]) \r Serial #: \(serialItem[indexPath.row]) \r Bought At: \(boughtItem[indexPath.row]) \r Phone #: \(phoneItem[indexPath.row]) \r Price: $\(priceItem[indexPath.row]) \r Purchase Date: \(purchaseDateItem[indexPath.row]) \r Expire Date: \(endDateItem[indexPath.row]) \r Notes: \(notesItem[indexPath.row]) \r" //array[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "View Photo or Edit", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Receipt Photo", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.performSegueWithIdentifier("homeToReceiptImage", sender: self)
            
        }))
            
        alert.addAction(UIAlertAction(title: "Warranty Photo", style: .Default, handler: { action in
                
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.performSegueWithIdentifier("homeToWarrantyImage", sender: self)
            
        }))
            
        alert.addAction(UIAlertAction(title: "Edit Warranty", style: .Default, handler: { action in
                
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            self.performSegueWithIdentifier("homeToEdit", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        

       
        parseObjectIdEdit = parseObjectId[indexPath.row]
        parseImage = parseObjectId[indexPath.row]
        newItemEdit = newItemItem[indexPath.row]
        modelEdit = modelItem[indexPath.row]
        serialEdit = serialItem[indexPath.row]
        boughtEdit = boughtItem[indexPath.row]
        phoneEdit = phoneItem[indexPath.row]
        priceEdit = priceItem[indexPath.row]
        purchaseDateEdit = purchaseDateItem[indexPath.row]
        endDateEdit = endDateItem[indexPath.row]
        notesEdit = notesItem[indexPath.row]
        
        performSegueWithIdentifier("homeToEdit", sender: self)
        
    }
    
    func getWarranties() {
        
        
        let query = PFQuery(className:"Warranties")
        query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        query.orderByAscending("endDate")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) warranties.")
            
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        print(object.objectId)
                    
                        newItemItem.append(object["product"] as! String)
                        modelItem.append(object["model"] as! String)
                        serialItem.append(object["serial"] as! String)
                        boughtItem.append(object["bought"] as! String)
                        phoneItem.append(object["phone"] as! String)
                        priceItem.append(object["price"] as! String)
                        purchaseDateItem.append(object["purchaseDate"] as! String)
                        endDateItem.append(object["endDate"] as! String)
                        notesItem.append(object["notes"] as! String)
                        parseObjectId.append(object.objectId!)
                        
                    }
                    print(parseObjectId)
                    print(newItemItem)
                    print(modelItem)
                    print(serialItem)
                    print(boughtItem)
                    print(phoneItem)
                    print(priceItem)
                    print(purchaseDateItem)
                    print(endDateItem)
                    print(notesItem)
                }
               
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            self.tableView.reloadData()
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        scrollView.contentSize.height = 667
        scrollView.contentSize.width = 300
        
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        //let nibName = UINib(nibName: "TableViewCell", bundle:nil)
        //self.tableView.registerNib(nibName, forCellReuseIdentifier: "Cell1")
        
    }
    
    func refresh(sender:AnyObject){
        
        // Updating your data here...
        //self.refreshControl!.endRefreshing()
        
        newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        parseObjectId = []
        
        getWarranties()
        //self.tableView.reloadData()
        
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        self.refreshControl!.endRefreshing()
        
    }

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let query = PFQuery(className:"Warranties")
            query.whereKey("objectId", equalTo: parseObjectId[indexPath.row])
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                
                    print("Successfully retrieved \(objects!.count) warranties.")
    
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            
                            print(object.objectId)
                            
                            object.deleteInBackground()
                            
                        }
                       
                        print("Successfully deleted warranty.")
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
                self.tableView.reloadData()
            }
            
            
        }
       
    }
    
    func noInternetConnection() {
        
        if Reachability.isConnectedToNetwork() == true {
            
            print("Internet connection OK")
            
            print(userEmail)
            
            newItemItem = []
            modelItem = []
            serialItem = []
            boughtItem = []
            phoneItem = []
            priceItem = []
            purchaseDateItem = []
            endDateItem = []
            notesItem = []
            parseObjectId = []
            
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
        
        if PFUser.currentUser() == nil {
            
            self.performSegueWithIdentifier("homeToLogin", sender: self)
            
        } else {
            
            noInternetConnection()
            
            getWarranties()
            
            pushNotification()
           
        }
        
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()

    }
    
    func pushNotification() {
        
        var product = String()
        var model = String()
        var expDate = String()
        
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.stringFromDate(date)
        print(currentDate)
        
        // Create our Installation query
        let pushQuery = PFQuery(className: "Warranties")
        pushQuery.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        pushQuery.whereKey("endDate", greaterThan: "")
        pushQuery.whereKey("pushSent", notEqualTo: "yes")
        pushQuery.whereKey("endDate", lessThan: currentDate)
        pushQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print(PFUser.currentUser()!.objectId!)
                print(currentDate)
                print("Successfully retrieved \(objects!.count) warranties for push.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        print(object.objectId)
                        product = object["product"] as! String
                        model = object["model"] as! String
                        expDate = object["endDate"] as! String
                        
                        print("\(objects.count) Push notifications being sent.")
                        
                        // Send a notification to all devices subscribed to the "expireDate" channel.
                        let push = PFPush()
                        //push.setQuery(pushQuery)
                        push.setChannel("expireDate")
                        push.setMessage("Your warranty for " + product + " " + model + " has expired on " + expDate + ".")
                        push.sendPushInBackground()
                        
                        object["pushSent"] = "yes"
                        object.saveInBackground()
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) ")
            }
        }

    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

