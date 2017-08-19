//
//  ProductSerialization.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

/*
 {
 "id": 0,
 "productDescription": "0 - Lorem ipsum qwc ykepzxeruclzvdbnauomuchouwdbrkyhf",
 "image": {
 "width": 150,
 "height": 492,
 "url": "http://lorempixel.com/150/492/city/id-0"
 },
 "price": 937
 }
 */

struct ProductSerialization {
    /// Gets product entity from Any, this Any is a dictionary, typically one of the values of a JSON
    ///    array returned from a key resulting from JSON deserialization
    ///
    /// - Parameter object: Object in JSON
    /// - Returns: Product entity
    static func product(from object: Any) -> ProductEntity {
        guard let dict = object as? NSDictionary else { fatalError("Invalid JSON format") }
        let product =
            ProductEntity(id: SerializationUtilities.number(from: dict, for: "id")?.intValue ?? 0)
        populate(product: product, from: object)
        return product
    }
    
    /// Populate a product class with data from JSON, used when there is data with the same ID
    ///
    /// - Parameters:
    ///   - product: The product object to fill
    ///   - jsonObject: The JSON to get data from
    static func populate(product: ProductEntity, from jsonObject: Any) {
        guard let dict = jsonObject as? NSDictionary else { fatalError("Invalid JSON format") }
        product.image = ProductSerialization.image(from: dict) as AnyObject
        product.price = SerializationUtilities.number(from: dict, for: "price")?.intValue ?? 0
        product.saved = false
        product.productDescription = SerializationUtilities.string(from: dict, for: "productDescription")
    }
    
    static func image(from object: Any) -> ImageEntity {
        guard let imageObject = (object as? NSDictionary)?["image"] as? NSDictionary else {
            fatalError("No image key")
        }
        return ImageEntity(url: SerializationUtilities.string(from: imageObject, for: "url")
            , width: (SerializationUtilities.number(from: imageObject, for: "width")?.intValue) ?? 0
            , height: (SerializationUtilities.number(from: imageObject, for: "height")?.intValue) ?? 0)
    }
}
