//
//  Classes.swift
//  Lenote
//
//  Created by Wallace Toh on 23/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotesManager {
    var managedObjectContext: NSManagedObjectContext
    
    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("Lenote", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.URLByAppendingPathComponent("Lenote.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func createFolderWithName(name: String!) {
        let folder = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext:managedObjectContext) as! Folder
        
        folder.setValue(name, forKey: "title")

        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func deleteFolder(folder: Folder!) {
        let folderObject: NSManagedObject = folder as NSManagedObject
        managedObjectContext.deleteObject(folderObject)
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func fetchFolders() -> NSArray? {
        let context = managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Folder")
        
        do {
            let fetchedFolders = try context.executeFetchRequest(fetchRequest) as! [Folder]

            return fetchedFolders
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
}