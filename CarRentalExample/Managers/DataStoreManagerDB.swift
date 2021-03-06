//
//  DataStoreManagerDB.swift
//  CarRentalExample
//
//  Created by Bob Pascazio on 11/12/15.
//  Copyright © 2015 PACE. All rights reserved.
//

import UIKit
import CoreData

class DataStoreManagerDB: NSObject {
   
    var customers:[CustomerDB]? = [CustomerDB]()

    class var sharedInstance: DataStoreManagerDB {
        struct Singleton {
            static let instance = DataStoreManagerDB()
        }
        return Singleton.instance
    }
    
    override init() {
        
        super.init()
  
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CustomerDB")
        
        do {
            
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [CustomerDB]
            
            if let results = fetchedResults {
                customers = results
            } else {
                print("error fetching from database")
            }
            
        } catch let error as NSError {

            print("Fetch failed: \(error.localizedDescription)")
        
        }
        
    }
    
    func getCustomerList() -> [CustomerDB]? {
        
        return customers
    }
    
    func createCustomer() -> CustomerDB? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
            
        let entity = NSEntityDescription.entityForName("CustomerDB", inManagedObjectContext: managedContext)
            
        let customer:CustomerDB? = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext) as? CustomerDB
        
        return customer
        
    }
    
    func saveContext() {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        do {

            try managedContext.save()
            
            let fetchRequest = NSFetchRequest(entityName: "CustomerDB")
            
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [CustomerDB]
            
            if let results = fetchedResults {
                customers = results
            } else {
                print("error fetching from database")
            }
            
        } catch let error as NSError {
            
            print("save failed: \(error.localizedDescription)")
            
        }
        
    }

}