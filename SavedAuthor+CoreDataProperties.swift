//
//  SavedAuthor+CoreDataProperties.swift
//  
//
//  Created by Timothey Urbanovich on 13/09/2022.
//
//

import Foundation
import CoreData


extension SavedAuthor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedAuthor> {
        return NSFetchRequest<SavedAuthor>(entityName: "SavedAuthor")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: String?

}
