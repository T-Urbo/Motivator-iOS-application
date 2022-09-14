//
//  CoreDataService.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 13/09/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {
    
    var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let persistantContainer: NSPersistentContainer
    static let shared: CoreDataService = CoreDataService()
    
    init() {
        persistantContainer = NSPersistentContainer(name: "SavedContent")
        persistantContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable To Initialize Core Data: \(error)")
            }
            
            
            
        }
    }
    
    func fetchItems() {
        
    }
    
    func saveDataToMemory() {
        
    }
    
    func deleteDataFromMemory() {
        
    }
}
