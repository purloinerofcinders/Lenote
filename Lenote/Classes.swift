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
import SwiftDate

class NotesManager {
    let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
    
    var managedContext: NSManagedObjectContext
    
    //MARK: - Core Data
    init() {
        managedContext = appDelegate.managedObjectContext
    }
    
    //MARK: - General Data
    func saveContext() {
        do {
            try managedContext.save()
        } catch {
            fatalError("Failed to save context with error: \(error)")
        }
    }
    
    func deleteAllData() {
        let notes = fetchNotes()
        
        for note in notes! {
            let noteObject: NSManagedObject = note as! NSManagedObject
            managedContext.deleteObject(noteObject)
        }
        
        saveContext()
    }
    
    //MARK: - Note Setters
    func createNoteWithTitle(title: String) -> Note {
        let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext:managedContext) as! Note
        
        note.title = title
        note.createdDate = NSDate()
        
        saveContext()
        
        return note
    }
    
    func saveNote(note: Note!, title: String, content: String) {
        note.title = title
        
        saveContext()
    }
    
    func deleteNote(note: Note!) {
        let noteObject: NSManagedObject = note as NSManagedObject
        
        for post in note.posts! {
            let postObject: NSManagedObject = post as! NSManagedObject
            let entryObject: NSManagedObject = (post as! Post).entry! as NSManagedObject
            
            managedContext.deleteObject(postObject)
            managedContext.deleteObject(entryObject)
        }
        
        managedContext.deleteObject(noteObject)
        
        saveContext()
    }
    
    func deleteAllNotes() {
        let context = managedContext
        let fetchRequest = NSFetchRequest(entityName: "Note")
        var fetchedNotes = [Note]()
        
        do {
            fetchedNotes = try context.executeFetchRequest(fetchRequest) as! [Note]
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
        
        for note in fetchedNotes {
            let noteObject: NSManagedObject = note as NSManagedObject
            managedContext.deleteObject(noteObject)
        }
        
        saveContext()
    }
    
    //MARK: - Note Getters
    func fetchNotes() -> NSArray? {
        let context = managedContext
        let fetchRequest = NSFetchRequest(entityName: "Note")
        
        do {
            let fetchedNotes = try context.executeFetchRequest(fetchRequest) as! [Note]
            
            return fetchedNotes
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
    }
    
    //MARK: - Post Getters
    func fetchPostsSortedByCreatedDateFromNote(note: Note) -> NSArray? {
        let fetchedPosts = note.posts
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        let sortedPosts = fetchedPosts?.sortedArrayUsingDescriptors([sortDescriptor])
        
        return sortedPosts
    }
    
    //MARK: - Post Setters
    func createPostInNote(note: Note, type: NSInteger) {
        let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext:managedContext) as! Post
        
        post.type = type
        post.note = note
        post.createdDate = NSDate()
        
        switch type {
        case 0:
            let entry = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext:managedContext) as! Entry
            
            post.entry = entry
            
        case 1:
            let checklist = NSEntityDescription.insertNewObjectForEntityForName("Checklist", inManagedObjectContext: managedContext) as! Checklist
            
            post.checklist = checklist
            
        default:
            break
        }
        
        saveContext()
    }
    
    func deletePost(post: Post, type: NSInteger) {
        let postObject: NSManagedObject = post as NSManagedObject
        
        switch type {
        case 0:
            let entryObject: NSManagedObject = post.entry! as NSManagedObject
            
            managedContext.deleteObject(entryObject)
            
            
        case 1:
            let checklistObject: NSManagedObject = post.checklist! as NSManagedObject
            
            managedContext.deleteObject(checklistObject)
            
        default:
            break
        }
        
        managedContext.deleteObject(postObject)
        
        saveContext()
    }
    
    //MARK: - Checklist Setters
    func createItemInChecklist(checklist: Checklist) {
        let item = NSEntityDescription.insertNewObjectForEntityForName("ChecklistItem", inManagedObjectContext:managedContext) as! ChecklistItem
        
        item.title = ""
        item.checklist = checklist
        
        saveContext()
    }
    
    func updateItemTitle(item: ChecklistItem, title: String) {
        item.title = title
        
        saveContext()
    }
    
    //MARK: - Checklist Getters
    func fetchItemsInChecklist(checklist: Checklist) -> NSArray {
        let fetchedItems = checklist.items
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let sortedItems = fetchedItems?.sortedArrayUsingDescriptors([sortDescriptor])
        
        return sortedItems!
    }
    
    //MARK: - Debugging
    func fetchAllEntitiesCount() {
        let context = managedContext
        var fetchRequest = NSFetchRequest(entityName: "Note")
        
        do {
            let fetchedNotes = try context.executeFetchRequest(fetchRequest) as! [Note]
            
            print(String(format:"Notes: %i", fetchedNotes.count))
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Post")
        
        do {
            let fetchedPosts = try context.executeFetchRequest(fetchRequest) as! [Post]
            
            print(String(format:"Posts: %i", fetchedPosts.count))
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Entry")
        
        do {
            let fetchedEntries = try context.executeFetchRequest(fetchRequest) as! [Entry]
            
            print(String(format:"Entries: %i", fetchedEntries.count))
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Checklist")
        
        do {
            let fetchedChecklists = try context.executeFetchRequest(fetchRequest) as! [Checklist]
            
            print(String(format:"Checklists: %i", fetchedChecklists.count))
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "ChecklistItem")
        
        do {
            let fetchedChecklistItems = try context.executeFetchRequest(fetchRequest) as! [ChecklistItem]
            
            print(String(format:"Checklist Items: %i", fetchedChecklistItems.count))
        } catch {
            fatalError("Failed to fetch with error: \(error)")
        }
        
        print("////////////////////////////////////////")
    }
}

class DateManager {
    func dateToString(date: NSDate, type: NSInteger) -> String? {
        switch type {
        case 0:
            return date.toString(.LongStyle)
        
        case 1:
            return date.toString(.MediumStyle)
            
        case 2:
            return date.toString(.ShortStyle)
            
        default:
            return nil
        }
    }
}