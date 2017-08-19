//
//  WritableRepository.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

protocol WritableRepository: Repository {
    func write(object: T, completion: @escaping (Error?) -> ())
}
