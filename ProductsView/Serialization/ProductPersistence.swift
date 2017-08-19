//
//  ProductPersistence.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit
import CoreData

struct ProductPersistence {
    
    /// The database background queue
    static let dataBackgroundQueue : DispatchQueue = {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }()
    
    static func object(fromManagedObject managedObject: ProductManagedObject) -> ProductEntity {
        let product = ProductEntity(id: Int(managedObject.web_id))
        populate(product: product, fromManaged: managedObject)
        return product
    }
    
    static func populate(product: ProductEntity, fromManaged managedObject: ProductManagedObject) {
        product.productDescription = managedObject.productDescription
        product.price = Int(managedObject.price)
        product.image = ImageEntity(url: managedObject.imageUrl
            , width: Int(managedObject.imageWidth)
            , height: Int(managedObject.imageHeight)) as AnyObject
        // This came from database, so it is saved before
        product.saved = true
    }
    
    /// Inserts managed object from product into the managed context
    ///
    /// - Parameters:
    ///   - product: Product to save
    ///   - context: Managed object context of the database
    ///   - completion: What to call after
    static func insertManagedObject(fromProduct product: ProductEntity,
                                    inContext context: NSManagedObjectContext,
                                    completion: @escaping (Error?) -> ()) {
        createManagedObject(fromProduct: product, inContext: context) {
            product in
            if let prod = product {
                context.insert(prod)
                do {
                    try context.save()
                    completion(nil)
                } catch let err {
                    completion(err)
                }
            }
        }
    }
    
    /// Creates a ProductManagedObject from a product entity
    ///
    /// - Parameters:
    ///   - product: Product entity
    ///   - context: Managed object context of the database
    ///   - completion: What to call after making, this is a closure that recieves the created object
    static func createManagedObject(fromProduct product: ProductEntity,
                                    inContext context: NSManagedObjectContext,
                                    completion: @escaping (ProductManagedObject?) -> ()) {
        dataBackgroundQueue.async {
            guard let description = NSEntityDescription.entity(forEntityName: "Product", in: context) else {
                fatalError("Can't get description")
            }
            let ret = ProductManagedObject(entity: description, insertInto: context)
            if let image = product.image as? ImageEntity {
                ret.imageHeight = Int16(image.height)
                ret.imageWidth = Int16(image.width)
                ret.imageUrl = image.url
            }
            ret.web_id = Int32(product.id)
            ret.productDescription = product.productDescription
            ret.price = Int32(product.price)
            completion(ret)
        }
    }
}
