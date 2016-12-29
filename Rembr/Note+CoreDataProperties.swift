//
//  Note+CoreDataProperties.swift
//  Rembr
//
//  Created by Askar Mustafin on 12/29/16.
//  Copyright © 2016 asich. All rights reserved.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note");
    }

    @NSManaged public var enword: String?
    @NSManaged public var ruword: String?
    @NSManaged public var dateAdded: Date?

}
