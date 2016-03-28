//
//  MasterViewController.swift
//  ContactsPerfTest
//
//  Created by Philipp Engel on 25/03/16.
//  Copyright © 2016 Philipp Engel. All rights reserved.
//

import UIKit
import AddressBook

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    let addrBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        requestContacts()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    
    func requestContacts() {
        let status = ABAddressBookGetAuthorizationStatus()
        
        switch status {
        case .Denied, .Restricted:
            print("Access already denied")
            UIAlertView.init(title: nil, message: "This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app.", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        case .Authorized:
            print("Access already authorized")
            loadContactsOld()
        case .NotDetermined:
            print("Access not yet determined")
            promptForAddressBookAccess(addrBookRef)
        }
        
    }
    
    func loadContactsOld() {
        
        let now = NSDate()
        
        let people = ABAddressBookCopyArrayOfAllPeople(addrBookRef).takeRetainedValue() as NSArray as [ABRecord]
        
        print("\(people.count) contacts. execution time: \(NSDate().timeIntervalSinceDate(now)*1000)")
        
        for person in people {
            guard let compositeName = ABRecordCopyCompositeName(person) else { continue }
            guard let phones = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue() as? ABMultiValueRef else { continue }
            
            var numberString = ""
            for (var i = 0; i < ABMultiValueGetCount(phones); i += 1) {
                guard let nr = ABMultiValueCopyValueAtIndex(phones, i) else { continue }
                numberString = numberString + (nr.takeRetainedValue() as! String)
                numberString += " "
            }
            
            let name = compositeName.takeRetainedValue() as String
            
            //print(name, ": ", numberString)
        }
        
        print("\(people.count) contacts. execution time: \(NSDate().timeIntervalSinceDate(now)*1000)")
    }
    
    
    func promptForAddressBookAccess(addrBook: ABAddressBookRef!) {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(addrBook) { (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if granted {
                    print("Addressbook Access granted")
                    self.loadContactsOld()
                } else {
                    print("Addressbook Access denied")
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

