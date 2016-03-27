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
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    var managedContext: NSManagedObjectContext
    
    //MARK: - Core Data
    init() {
        managedContext = appDelegate.managedObjectContext
    }
    
    //MARK: - General Data
    func deleteAllData() {
        let notes = fetchNotes()
        
        for note in notes! {
            let noteObject: NSManagedObject = note as! NSManagedObject
            managedContext.deleteObject(noteObject)
        }
        
        let folders = fetchFolders()
        
        for folder in folders! {
            let folderObject: NSManagedObject = folder as! NSManagedObject
            managedContext.deleteObject(folderObject)
        }
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //MARK: - Folder Setters
    func createFolderWithName(title: String!) {
        let folder = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext:managedContext) as! Folder
        
        folder.title = title

        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func deleteFolder(folder: Folder!) {
        let folderObject: NSManagedObject = folder as NSManagedObject
        managedContext.deleteObject(folderObject)
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //MARK: - Folder Getters
    func fetchFolders() -> NSArray? {
        let context = managedContext
        let fetchRequest = NSFetchRequest(entityName: "Folder")
        
        do {
            let fetchedFolders = try context.executeFetchRequest(fetchRequest) as! [Folder]
            
            return fetchedFolders
        } catch {
            fatalError("Failed to fetch folders: \(error)")
        }
    }
    
    //MARK: - Note Setters
    func createNoteWithTitle(title: String!, folder: Folder!) {
        let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext:managedContext) as! Note
        
        note.title = title
        note.folder = folder
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //MARK: - Note Getters
    func fetchNotes() -> NSArray? {
        let context = managedContext
        let fetchRequest = NSFetchRequest(entityName: "Note")
        
        do {
            let fetchedNotes = try context.executeFetchRequest(fetchRequest) as! [Note]
            
            return fetchedNotes
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }
    
    func fetchNotesFromFolder(folder: Folder!) -> NSArray? {
        let context = managedContext
        let fetchRequest = NSFetchRequest(entityName: "Folder")
        
        fetchRequest.predicate = NSPredicate(format: "title == %@", folder.title!)
        
        do {
            let folder: Folder = try context.executeFetchRequest(fetchRequest).first as! Folder
            
            return folder.notes?.allObjects
        } catch {
            fatalError("Failed to fetch notes: \(error)")
        }
    }
}