//
//  IDProtocol.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import Foundation

/// A protocol that defines any object that has an ID, extends NSObjectProtocol to be object bound
protocol IDProtocol: NSObjectProtocol {
    associatedtype Identity
    
    var id: Identity { get }
    
    init(id: Identity)
    
    func copyData(from: Self)
}
