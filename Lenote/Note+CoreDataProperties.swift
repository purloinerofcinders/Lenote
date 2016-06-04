//
//  Note+CoreDataProperties.swift
//  Lenote
//
//  Created by Wallace Toh on 4/6/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var createdDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var posts: NSSet?

}
