//
//  Folder+CoreDataProperties.swift
//  Lenote
//
//  Created by Wallace Toh on 25/3/16.
//  Copyright © 2016 Wallace Toh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Folder {

    @NSManaged var title: String?
    @NSManaged var notes: NSSet?

}
