//
//  ProductDataInMemory.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class ProductDataInMemory: GeneralDataInMemoryByID<ProductEntity> {
    static let shared = ProductDataInMemory()
}
