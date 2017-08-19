//
//  ProductEntity.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class ProductEntity: NSObject, IDProtocol {
    // Used @objc dynamic to make them observable using Key-Value Observation
    @objc dynamic let id: Int
    /// An ImageEntity that represents the image, used AnyObject here to be Key-Value Observable
    @objc dynamic var image: AnyObject?
    @objc dynamic var productDescription: String?
    @objc dynamic var price: Int = 0
    
    /// Is this entity saved in the local database?
    @objc dynamic var saved: Bool = false
    
    required init(id: Int) {
        self.id = id
        super.init()
    }
    
    func copyData(from: ProductEntity) {
        image = (from.image as? ImageEntity) as AnyObject
        productDescription = from.productDescription
        price = from.price
        saved = from.saved
    }
}
