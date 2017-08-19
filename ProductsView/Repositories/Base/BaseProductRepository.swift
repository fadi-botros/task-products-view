//
//  BaseProductRepository.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class BaseProductRepository: Repository {
    func object(by id: Int, completion: @escaping (ProductEntity?, Error?) -> ()) {
        fatalError("Not implemented")
    }
    
    func objects(for range: Range<Int>, completion: @escaping ([ProductEntity]?, Error?) -> ()) {
        fatalError("Not implemented")
    }
}

class BaseWritableProductRepository: BaseProductRepository, WritableRepository {
    func write(object: ProductEntity, completion: @escaping (Error?) -> ()) {
        fatalError("Not implemented")
    }
}
