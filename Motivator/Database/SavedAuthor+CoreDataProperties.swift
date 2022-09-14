//
//  SavedAuthor+CoreDataProperties.swift
//  
//
//  Created by Timothey Urbanovich on 14/09/2022.
//
//

import Foundation
import CoreData
import UIKit


extension SavedAuthor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedAuthor> {
        return NSFetchRequest<SavedAuthor>(entityName: "SavedAuthor")
    }

    @NSManaged public var image: UIImage
    @NSManaged public var name: String

}
