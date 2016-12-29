//
//  CoreDataHelper.swift
//  Rembr
//
//  Created by Askar Mustafin on 12/27/16.
//  Copyright © 2016 asich. All rights reserved.
//

import Cocoa

class CoreDataHelper {
    

    /**
        Fetch all instance of provided entity

        - Parameter entity: Entity whose array should be returned closure
        - Parameter callback: Closure by which will be provided an array of NSManagedObject

        - Returns: void

    */
    static func fetch(entity : String, callback : (([NSManagedObject]) -> ())?) {
        
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        do {
            
            let results = try managedContext.fetch(fetchRequest)
            
            if callback != nil {
                callback!(sortNotes(result: results as! [NSManagedObject] as! [Note]))
            }
            
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        
    }
    
    static func sortNotes(result: [Note]) -> [Note] {
        
        return result.sorted { (item1, item2) -> Bool in
            
            let t1 = item1.dateAdded ?? Date.distantPast
            let t2 = item2.dateAdded ?? Date.distantPast
            
            return t1 > t2
        }
    }

    /**
        Save NSManagedObject

        - Parameter enWord:
        - Parameter ruWord:
        - Parameter callback:

        - Returns: void
    */
    static func write(enWord: String, ruWord: String, callback : ((NSManagedObject) -> ())?) {
        
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entity(forEntityName: "Note", in:managedContext)
        let word = NSManagedObject(entity: entity!, insertInto: managedContext)

        word.setValue(enWord, forKey: "enword")
        word.setValue(ruWord, forKey: "ruword")
        
        word.setValue(NSDate(), forKey: "dateAdded")

        do {

            try managedContext.save()

            if callback != nil {
                callback!(word)
            }

        } catch {
            print("Could not save")
        }
    }
    
    
    static func delete(word : NSManagedObject, callback : (() -> ())?) {

        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        managedContext.delete(word)

        do {

            try managedContext.save()

            if callback != nil {
                callback!()
            }

        } catch {

            print("Could not save managedContext")

        }
    }

    static func deleteAll(entity : String) {

        let appDelegate = NSApplication.shared().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }

        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }

    }

}
