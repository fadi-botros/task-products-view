//
//  Repository.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

protocol Repository {
    associatedtype E: Comparable
    associatedtype T: IDProtocol
    
    func objects(for range: Range<E>, completion: @escaping ([T]?, Error?) -> ())
    func object(by id: E, completion: @escaping (T?, Error?) -> ())
}
