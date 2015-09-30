//
//  WarrantiesViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 8/31/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
//import CoreData
import Parse

//var array:[String] = [String]()

//var parseObjectId = [String]()

class WarrantiesTableViewController: UITableViewController {
    
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newItemItem.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let reuseIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell!
        /*if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: cellIdentifier)
        }*/

        
        cell!.textLabel!.numberOfLines = 0
        
        cell!.textLabel!.font = UIFont.systemFontOfSize(18)
        
        cell!.textLabel!.text = " Product: \(newItemItem[indexPath.row]) \r Model #: \(modelItem[indexPath.row]) \r Serial #: \(serialItem[indexPath.row]) \r Bought At: \(boughtItem[indexPath.row]) \r Phone #: \(phoneItem[indexPath.row]) \r Price: $\(priceItem[indexPath.row]) \r Purchase Date: \(purchaseDateItem[indexPath.row]) \r Warranty Expires: \(endDateItem[indexPath.row]) \r Notes: \(notesItem[indexPath.row]) \r"
        
        return cell!
    }
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        parseObjectIdEdit = parseObjectId[indexPath.row]
        
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
        query.orderByDescending("endDate")
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
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
            }
           
            self.tableView.reloadData()
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
            
            getWarranties()
            
            
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

