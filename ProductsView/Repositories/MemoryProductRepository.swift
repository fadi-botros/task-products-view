//
//  MemoryProductRepository.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

/// This gets and writes product data in memory.
class MemoryProductRepository: BaseWritableProductRepository {
    override func objects(for range: Range<Int>, completion: @escaping ([ProductEntity]?, Error?) -> ()) {
        var productsToReturn : [ProductEntity] = []
        for i in range.lowerBound...range.upperBound {
            object(by: i) { object, _ in
                if let obj = object { productsToReturn.append(obj) }
            }
        }
        completion(productsToReturn, nil)
    }
    
    override func object(by id: Int, completion: @escaping (ProductEntity?, Error?) -> ()) {
        completion(ProductDataInMemory.shared.memory.object(forKey: id as NSNumber), nil)
    }
    
    override func write(object: ProductEntity, completion: @escaping (Error?) -> ()) {
        ProductDataInMemory.shared.memory.setObject(object, forKey: object.id as NSNumber)
        completion(nil)
    }
}
