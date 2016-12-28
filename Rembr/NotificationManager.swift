//
//  NotificationManager.swift
//  SwiftCoreData
//
//  Created by Askar Mustafin on 12/23/16.
//  Copyright © 2016 asich. All rights reserved.
//

import Cocoa

class NotificationManager: NSObject {

    
    var didStart : Bool = false
    
    func start() {
        
        if (!didStart) {
            Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(self.fire), userInfo: nil, repeats: true)
            didStart = true
        }
        
    }
    
    func stop() {
        didStart = false
    }
    
    func fire() {                
        
        let word = fetchRandomPair()
        postNotification(word: word!)
    }
    
    func fetchRandomPair() -> NSManagedObject? {
        
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        //3
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            let words = results as! [NSManagedObject]
            let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
            let randomWord = words[randomIndex]
            
            return randomWord
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func postNotification(word: NSManagedObject) {
        
        let enText = word.value(forKey: "enword") as? String ?? ""
        let ruText = word.value(forKey: "ruword") as? String ?? "Добавьте первое слово для запоминания"
        
        let notification = NSUserNotification.init()
        
        // set the title and the informative text
        notification.title = enText
        notification.informativeText = ruText
        
        // put the path to the created text file in the userInfo dictionary of the notification
//        notification.userInfo = ["path" : fileName]
        
        // use the default sound for a notification
        notification.soundName = "Hero"
        
        // if the user chooses to display the notification as an alert, give it an action button called "View"
        notification.hasActionButton = false
        //notification.actionButtonTitle = "View"
        
        // Deliver the notification through the User Notification Center
        NSUserNotificationCenter.default.deliver(notification)
        
    }
}
