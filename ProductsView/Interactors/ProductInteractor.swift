//
//  ProductInteractor.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class ProductInteractor {
    static let shared = ProductInteractor()
    
    /// Page loaded notification, parameter: Range<Int> beginning, end
    static let pageLoadedNotification = Notification.Name(rawValue: "pageLoaded")
    /// Update from database, parameter: [Int] the IDs changed
    static let dataUpdatedFromDatabase = Notification.Name(rawValue: "databaseData")
    /// Error loading from web notification, parameter: Error
    static let errorNotification = Notification.Name(rawValue: "error")
    /// Resetting notification, nil parameter
    static let resetNotification = Notification.Name(rawValue: "reset")
    
    let repositories = [
        MemoryProductRepository(),
        FromDatabaseProductRepository.shared,
        FromAPIProductRepository()
    ]
    
    private var _currentPage = 0
    
    private var loading = false
    
    let pageCount = 20
    
    var currentPage: Int { return _currentPage }
    
    var isLoading: Bool { return loading }
    
    var count: Int { return ProductDataInMemory.shared.memory.count }
    
    /// Gets data, first from memory, then from database, then from web
    ///
    /// - Parameter i: Index
    subscript(i: Int) -> ProductEntity? {
        return oneObject(by: i)
    }
    
    func reset() {
        _currentPage = 0
        ProductDataInMemory.shared.memory.removeAllObjects()
        NotificationCenter.default.post(name: ProductInteractor.resetNotification, object: nil)
    }
    
    private func object(fromMemoryRepository index: Int) -> ProductEntity? {
        var productEntity: ProductEntity?
        // This closure is not dangerous because it happens on the same thread
        repositories[0].object(by: index, completion: { entity, _ in
            if let ent = entity {
                productEntity = ent
            }
        })
        return productEntity
    }
    
    /// Saves the object of the specified id in the local database
    ///
    /// - Parameter id: The id to save the object of
    func save(of id: Int) {
        guard let entity = self.object(fromMemoryRepository: id) else { fatalError("No object with this ID") }
        (repositories[1] as? BaseWritableProductRepository)?.write(object: entity) {_ in 
            DispatchQueue.main.async {
                entity.saved = true
            }
        }
    }
    
    /// Changes data of an existing entity in memory if existing, and put it in memory from scratch
    ///   if it is new
    ///
    /// - Parameter entity: New data
    private func putObjectOrChangeState(entity: ProductEntity) {
        if let memEnt = self.object(fromMemoryRepository: entity.id) {
            // The saved one have priority over loaded now one
            if !(memEnt.saved == true && entity.saved == false) {
                memEnt.copyData(from: entity)
            }
        } else {
            (self.repositories[0] as? BaseWritableProductRepository)?
                .write(object: entity, completion: { _ in })
        }
    }
    
    func oneObject(by index: Int) -> ProductEntity? {
        // If out of range? read new page
        if index > (currentPage * pageCount) {
            readNewPage()
        }
        
        // Try to get it also from the database
        repositories[1].object(by: index, completion: { entity, _ in
            if let ent = entity {
                self.putObjectOrChangeState(entity: ent)
            }
        })
        
        // Get from memory for now, if any data is changed when read from other sources,
        //    it will be updated automatically
        return object(fromMemoryRepository: index)
    }
    
    func readNewPage() {
        
        // Don't try to load while loading
        guard !loading else { return }
        
        loading = true
        
        // A quick hack job (هندلة) to ensure the database is loaded
        while !(FromDatabaseProductRepository.databaseInitialized) {
            
        }
        
        let range = Range<Int>.init(
            uncheckedBounds: ((currentPage * pageCount), ((currentPage + 1) * pageCount)))
        // From the database, just read and wait the webservice, then notify that it is updated ONLY
        //    IF IT WAS LOADED BEFORE FROM THE WEB
        repositories[1].objects(for: range, completion: {data, err in
            guard let array = data else { return }
            var ids: [Int] = []
            array.forEach({self.putObjectOrChangeState(entity: $0); ids.append($0.id)})
            if !self.loading {
                NotificationCenter.default.post(name: ProductInteractor.dataUpdatedFromDatabase,
                                                object: ids)
            }
        })
        // From the API, when complete, notify
        repositories[2].objects(for: range, completion: {data, err in
            self.loading = false
            if let e = err {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: ProductInteractor.errorNotification, object: e)
                }
                return
            }
            guard let array = data else { return }
            array.forEach({self.putObjectOrChangeState(entity: $0)})
            self._currentPage += 1
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: ProductInteractor.pageLoadedNotification,
                                                object: range)
            }
            
        })
    }
}
