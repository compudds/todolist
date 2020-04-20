//
//  FirstViewController.swift
//  Warranty Wallet
//
//  Created by Eric Cook on 10/23/14.
//  Copyright (c) 2014 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse

var array:[String] = [String]()

var parseObjectId = [String]()

var parseImage = String()


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet var searchBarText: UISearchBar!
    
    var searchActive : Bool = false
    
    var filtered:[String] = []
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var refreshControl:UIRefreshControl!
    
    @IBOutlet  var tableView:UITableView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var logOut: UIButton!
    
    @IBAction func receiptImage(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToReceiptImage", sender: self)

    }
    
    @IBAction func warrantyImage(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToWarrantyImage", sender: self)
    }
    
    @IBAction func homeToAdd(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToAdd", sender: self)
    }
    
    @IBOutlet var editBtn: UIBarButtonItem!
    
    @IBAction func homeToEdit(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "homeToEdit", sender: self)
    }
    @IBAction func logOutBtn(_ sender: AnyObject) {
        
        newItemItem = []
        modelItem = []
        serialItem = []
        boughtItem = []
        phoneItem = []
        priceItem = []
        purchaseDateItem = []
        endDateItem = []
        notesItem = []
        warrantyItem = []
        receiptItem = []
        parseObjectId = []
        userEmail = ""
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "homeToLogin", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        if(searchActive) {
            
            return filtered.count
            
        } else {
            
            return newItemItem.count
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBarText.text = ""
        //getWarranties()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBarText.text = ""
        getWarranties()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = newItemItem.filter({ (text) -> Bool in
            
            let tmp: NSString = text as NSString
            
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return range.location != NSNotFound
        })
        
        
        if(filtered.count == 0){
            
            searchActive = false;
            
        } else {
            
            searchActive = true;
            
            newItemItem = []
            modelItem = []
            serialItem = []
            boughtItem = []
            phoneItem = []
            priceItem = []
            purchaseDateItem = []
            endDateItem = []
            notesItem = []
            warrantyItem = []
            receiptItem = []
            parseObjectId = []
            
            let search = searchText.lowercased()
            //let search2 = searchText.lowercased()
            
            print("searchText: \(searchText)")
            
            let query = PFQuery(className:"Warranties")
            query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
            query.whereKey("productSearch", contains: search)
            query.order(byAscending: "endDate")
            
            /*let query2 = PFQuery(className:"Warranties")
            query2.whereKey("userId", equalTo: PFUser.current()!.objectId!)
            query2.whereKey("productSearch", contains: search2)*/
            
            //let mainQuery = PFQuery.orQuery(withSubqueries: [query, query2]);
            //mainQuery.order(byAscending: "endDate")
            query.findObjectsInBackground {
                (objects, error) in
                
                if error == nil {
                    
                    print("Successfully retrieved \(objects!.count) warranties.")
                    
                    if let objects = objects {
                        for object in objects {
                            print(object.objectId!)
                            
                            newItemItem.append(object["product"] as! String)
                            modelItem.append(object["model"] as! String)
                            serialItem.append(object["serial"] as! String)
                            boughtItem.append(object["bought"] as! String)
                            phoneItem.append(object["phone"] as! String)
                            priceItem.append(object["price"] as! String)
                            purchaseDateItem.append(object["purchaseDate"] as! String)
                            endDateItem.append(object["endDate"] as! String)
                            notesItem.append(object["notes"] as! String)
                            warrantyItem.append(object["warranty"] as! PFFile)
                            receiptItem.append(object["receipt"] as! PFFile)
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
                    print("Error: \(error!)")
                }
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    let reuseIdentifier = "Cell1"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell?
        
        cell?.textLabel!.numberOfLines = 0
        
        cell?.textLabel!.lineBreakMode = .byWordWrapping
        
        cell?.textLabel!.font = UIFont.systemFont(ofSize: 18)
        
        if (searchActive == true){
            
            if (filtered.count == 0) {
                
                cell?.textLabel!.text = "No items found in search!"
                
            } else {
                
                cell?.textLabel!.text = filtered[(indexPath as NSIndexPath).row]
            }
            
            
        } else {
            
            cell?.textLabel!.text = " Product: \(newItemItem[(indexPath as NSIndexPath).row]) \r Model #: \(modelItem[(indexPath as NSIndexPath).row]) \r Serial #: \(serialItem[(indexPath as NSIndexPath).row]) \r Bought At: \(boughtItem[(indexPath as NSIndexPath).row]) \r Phone #: \(phoneItem[(indexPath as NSIndexPath).row]) \r Price: $\(priceItem[(indexPath as NSIndexPath).row]) \r Purchase Date: \(purchaseDateItem[(indexPath as NSIndexPath).row]) \r Expire Date: \(endDateItem[(indexPath as NSIndexPath).row]) \r Notes: \(notesItem[(indexPath as NSIndexPath).row])"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if(searchActive == false) {
            
             parseImage = parseObjectId[(indexPath as NSIndexPath).row]
            
         } else {
            
            
        }
        
        let alert = UIAlertController(title: "View Photo or Edit", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Receipt Photo", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            //parseImage = parseObjectId[indexPath.row]
            print(parseImage)
            
            self.performSegue(withIdentifier: "homeToReceiptImage", sender: self)
            
        }))
            
        alert.addAction(UIAlertAction(title: "Warranty Photo", style: .default, handler: { action in
                
            alert.dismiss(animated: true, completion: nil)
            
            //parseImage = parseObjectId[indexPath.row]
            print(parseImage)
            
            self.performSegue(withIdentifier: "homeToWarrantyImage", sender: self)
            
        }))
            
        alert.addAction(UIAlertAction(title: "Edit Warranty", style: .default, handler: { action in
                
            alert.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "homeToEdit", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.searchActive = false
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        if(searchActive == true) {
       
            parseObjectIdEdit = parseObjectId[(indexPath as NSIndexPath).row]
            
            newItemEdit = newItemItem[(indexPath as NSIndexPath).row]
            modelEdit = modelItem[(indexPath as NSIndexPath).row]
            serialEdit = serialItem[(indexPath as NSIndexPath).row]
            boughtEdit = boughtItem[(indexPath as NSIndexPath).row]
            phoneEdit = phoneItem[(indexPath as NSIndexPath).row]
            priceEdit = priceItem[(indexPath as NSIndexPath).row]
            purchaseDateEdit = purchaseDateItem[(indexPath as NSIndexPath).row]
            endDateEdit = endDateItem[(indexPath as NSIndexPath).row]
            notesEdit = notesItem[(indexPath as NSIndexPath).row]
            parseImage = parseObjectId[(indexPath as NSIndexPath).row]
            self.searchActive = false
            
            performSegue(withIdentifier: "homeToEdit", sender: self)

            
        } else {
            
            parseObjectIdEdit = parseObjectId[(indexPath as NSIndexPath).row]
            
            newItemEdit = newItemItem[(indexPath as NSIndexPath).row]
            modelEdit = modelItem[(indexPath as NSIndexPath).row]
            serialEdit = serialItem[(indexPath as NSIndexPath).row]
            boughtEdit = boughtItem[(indexPath as NSIndexPath).row]
            phoneEdit = phoneItem[(indexPath as NSIndexPath).row]
            priceEdit = priceItem[(indexPath as NSIndexPath).row]
            purchaseDateEdit = purchaseDateItem[(indexPath as NSIndexPath).row]
            endDateEdit = endDateItem[(indexPath as NSIndexPath).row]
            notesEdit = notesItem[(indexPath as NSIndexPath).row]
            warrantyEdit = [warrantyItem[(indexPath as NSIndexPath).row]]
            receiptEdit = [receiptItem[(indexPath as NSIndexPath).row]]
            
            performSegue(withIdentifier: "homeToEdit", sender: self)

            
        }
        
    }
    
    func getWarranties() {
        
        let query = PFQuery(className:"Warranties")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.order(byDescending: "endDate")
        query.findObjectsInBackground {
            (objects, error) in
            
            if error == nil {
                
                print("Successfully retrieved \(objects!.count) warranties.")
            
                if let objects = objects {
                    for object in objects {
                        print(object.objectId!)
                    
                        newItemItem.append(object["product"] as! String)
                        modelItem.append(object["model"] as! String)
                        serialItem.append(object["serial"] as! String)
                        boughtItem.append(object["bought"] as! String)
                        phoneItem.append(object["phone"] as! String)
                        priceItem.append(object["price"] as! String)
                        purchaseDateItem.append(object["purchaseDate"] as! String)
                        endDateItem.append(object["endDate"] as! String)
                        notesItem.append(object["notes"] as! String)
                        warrantyItem.append(object["warranty"] as! PFFile)
                        receiptItem.append(object["receipt"] as! PFFile)
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
                print("Error: \(error!)")
            }
            
            self.tableView.reloadData()
        }
        
        //self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        scrollView.contentSize.height = 667
        scrollView.contentSize.width = 250
        
        searchBarText.delegate = self
       
    }
    
    @objc func refresh(_ sender:AnyObject){
        
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
        self.tableView.reloadData()
        
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        
        self.refreshControl!.endRefreshing()
        
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let query = PFQuery(className:"Warranties")
            query.whereKey("objectId", equalTo: parseObjectId[(indexPath as NSIndexPath).row])
            query.findObjectsInBackground {
                (objects, error) in
                
                if error == nil {
                
                    print("Successfully retrieved \(objects!.count) warranties.")
    
                    if let objects = objects {
                        for object in objects {
                            
                            print(object.objectId!)
                            
                            object.deleteInBackground()
                            
                        }
                       
                        print("Successfully deleted warranty.")
                        
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
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
            
            let alert = UIAlertController(title: "Sorry, no internet connection found.", message: "Warranty Locker requires an internet connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { action in
                
                alert.dismiss(animated: true, completion: nil)
                self.noInternetConnection()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
          
               
        
        if PFUser.current() == nil {
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            self.performSegue(withIdentifier: "homeToLogin", sender: self)
            
        } else {
            
            noInternetConnection()
            
            getWarranties()
            
            pushNotification()
           
        }
        
    }
    
    func pushNotification() {
        
        var product = String()
        var model = String()
        var expDate = String()
        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: date)
        print(currentDate)
        
        // Create our Installation query
        let pushQuery = PFQuery(className: "Warranties")
        pushQuery.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        pushQuery.whereKey("endDate", notEqualTo: "")
        pushQuery.whereKey("endDate", lessThanOrEqualTo: currentDate)
        pushQuery.whereKey("pushSent", notEqualTo: "yes")
        pushQuery.findObjectsInBackground {
            (objects, error) in
            
            if error == nil {
                // The find succeeded.
               print(currentDate)
                print("Successfully retrieved \(objects!.count) warranties for push.")
                // Do something with the found objects
                if let objects = objects {
        
                    for object in objects {
                        print(object.objectId!)
                        product = object["product"] as! String
                        model = object["model"] as! String
                        expDate = object["endDate"] as! String
                        
                        print("\(objects.count) Push notifications being sent.")
                        /*
                        // Send a notification to all devices subscribed to the "expireDate" channel.
                        let push = PFPush()
                        //push.setQuery(pushQuery)
                        push.setChannel("expireDate")
                        push.setMessage("Your warranty for " + product + " " + model + " has expired on " + expDate + ".")
                        push.sendPushInBackground()*/
                        
                        
                        let alert = UIAlertController(title: "A Warranty Has Expired", message: "Your warranty for \(product) \(model) has expired on \(expDate).", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        self.scrollView.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

