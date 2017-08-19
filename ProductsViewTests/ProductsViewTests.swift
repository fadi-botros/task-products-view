//
//  ProductsViewTests.swift
//  ProductsViewTests
//
//  Created by mac on 8/18/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import XCTest
@testable import ProductsView

class ProductsViewTests: XCTestCase {
    
    var repositories: [BaseProductRepository] = []
    
    override func setUp() {
        super.setUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(databaseInitialized),
                                               name: FromDatabaseProductRepository.connectNotificationName,
                                               object: nil)
        
        synchronizationQueue.sync {
            repositories.append(MemoryProductRepository.init())
            repositories.append(FromDatabaseProductRepository.shared)
            repositories.append(FromAPIProductRepository.init())
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMemoryRepository() {
        let mem = repositories[0] as! BaseWritableProductRepository
        let productEntity = ProductEntity(id: 5)
        productEntity.price = 100
        mem.write(object: productEntity, completion: {err in XCTAssertNil(err)})
        mem.object(by: 5, completion: { entity, err in
            XCTAssertNil(err)
            XCTAssertEqual(entity?.id, productEntity.id)
            XCTAssertEqual(entity?.price, productEntity.price)
        })
    }
    
    let readingExpect = XCTestExpectation(description: "reading")
    let writingExpect = XCTestExpectation(description: "writing")
    
    let synchronizationQueue = { () -> DispatchQueue in 
        let ret = DispatchQueue(label: "sync",
                                qos: .background,
                                attributes: DispatchQueue.Attributes.init(rawValue: 0),
                                autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                target: nil)
        return ret
    } ()
    
//    func testDatabaseRepository() {
//        synchronizationQueue.sync {
//            wait(for: [readingExpect, writingExpect], timeout: 10)
//        }
//    }
//    
//    func databaseInitialized(_ notification: Notification) {
//        synchronizationQueue.async {
//            let rep = self.repositories[1] as! BaseWritableProductRepository
//            let productEntity = ProductEntity(id: 5)
//            productEntity.price = 100
//            rep.write(object: productEntity, completion: {err in
//                XCTAssertNil(err)
//                self.writingExpect.fulfill()
//                rep.object(by: 5, completion: { entity, err in
//                    XCTAssertNil(err)
//                    XCTAssertEqual(entity?.id, productEntity.id)
//                    XCTAssertEqual(entity?.price, productEntity.price)
//                    self.readingExpect.fulfill()
//                })
//            })
//        }
//    }
    
}
