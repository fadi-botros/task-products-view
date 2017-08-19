//
//  FromDatabaseProductRepositoryiOS10.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class FromDatabaseProductRepositoryiOS10: FromDatabaseProductRepository {
    
    override var managedObjectContext: NSManagedObjectContext? {
        return persistentContainer?.newBackgroundContext()
    }
    
    var persistentContainer: NSPersistentContainer?
    
    // This function "init(completionClosure:)" is from the Apple Documentation.
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html#//apple_ref/doc/uid/TP40001075-CH4-SW1
    
    /// Initializes the CoreData stack
    ///
    /// - Parameter completionClosure: The function to call after initializing
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "Products")
        persistentContainer?.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }

}
