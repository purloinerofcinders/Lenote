//
//  Post+CoreDataProperties.swift
//  Lenote
//
//  Created by Wallace Toh on 28/5/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var type: NSNumber?
    @NSManaged var createdDate: NSDate?
    @NSManaged var entry: Entry?
    @NSManaged var note: Note?
    @NSManaged var checklist: Checklist?

}
