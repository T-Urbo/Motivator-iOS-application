//
//  SavedQuote+CoreDataProperties.swift
//  
//
//  Created by Timothey Urbanovich on 14/09/2022.
//
//

import Foundation
import CoreData


extension SavedQuote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedQuote> {
        return NSFetchRequest<SavedQuote>(entityName: "SavedQuote")
    }

    @NSManaged public var quote: CoreDataQuoteModel?

}

extension SavedQuote: Identifiable {
    
}
