//
//  GeneralDataByID.swift
//  ProductsView
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class GeneralDataInMemoryByID<T: IDProtocol> {
    // For better performance, it would be strong to weak objects.
    // But this will complicate things here because the data is changing randomly and continuously
    let memory: NSMapTable<NSNumber, T> = NSMapTable<NSNumber, T>.strongToStrongObjects()
}
