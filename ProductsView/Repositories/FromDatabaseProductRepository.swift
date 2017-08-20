//
//  FromDatabase.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit
import CoreData

/// Repository to get products from local database.
/// This is a base class to be overridden in iOS < 10.0 and iOS >= 10.0
class FromDatabaseProductRepository: BaseWritableProductRepository {
    
    private func callDatabaseFunction(predicate: NSPredicate, then call: @escaping (Any?, Error?) -> ()) {
        guard let context = self.managedObjectContext else { call(nil, nil); return }
        ProductPersistence.dataBackgroundQueue.async {
            do {
                let request = NSFetchRequest<ProductManagedObject>(entityName: "Product")
                request.predicate = predicate
                let results = try context.fetch(request)
                call(results, nil)
            } catch let err {
                call(nil, err)
            }
        }
    }
    
    override func object(by id: Int, completion: @escaping (ProductEntity?, Error?) -> ()) {
        
        callDatabaseFunction(predicate: NSPredicate(format: "web_id == %@", id as NSNumber)) { data, error in
            if let object = (data as? [ProductManagedObject])?.first {
                completion(ProductPersistence.object(fromManagedObject: object), nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    override func objects(for range: Range<Int>, completion: @escaping ([ProductEntity]?, Error?) -> ()) {
        callDatabaseFunction(predicate:
        NSPredicate(format: "web_id >= %@ && web_id < %@", range.lowerBound as NSNumber, range.upperBound as NSNumber)) {
            data, error in
            if let array = data as? [ProductManagedObject] {
                completion(array.map({ProductPersistence.object(fromManagedObject: $0)}), nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    override func write(object: ProductEntity, completion: @escaping (Error?) -> ()) {
        if let managedObjectContext = self.managedObjectContext {
            ProductPersistence.insertManagedObject(fromProduct: object,
                                                   inContext: managedObjectContext,
                                                   completion: completion)
        }
    }
    
    /// Gets the managedObjectContext, override in subclasses
    var managedObjectContext: NSManagedObjectContext? {
        return nil
    }
    
    /// The notification name to be posted when database is connected
    static let connectNotificationName = NSNotification.Name.init(rawValue: "databaseConnected")
    
    /// Is database initialized?
    static var databaseInitialized: Bool = false
    
    /// The shared database repository instance.
    /// This is a kind of dependency injection, the caller doesn't know (and doesn't care) which
    ///     implementation is given here, but this function choose the suitable one and give it
    ///     to the caller (here according to the iOS version)
    static let shared: FromDatabaseProductRepository = {
        // Closure to be called after database initialization
        let closure: () -> () = {
            // Notify all who cares that the database is connected
            NotificationCenter.default.post(name: connectNotificationName, object: nil)
            // Set the status
            databaseInitialized = true
        }
        
        if #available(iOS 10.0, *) {
            return FromDatabaseProductRepositoryiOS10(completionClosure: closure)
        } else {
            return FromDatabaseProductRepositoryiOS9(completionClosure: closure)
        }
    }()
    
}
