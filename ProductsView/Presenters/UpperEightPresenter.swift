//
//  UpperEightPresenter.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

protocol UpperEightPresenterDelegate: NSObjectProtocol {
    func upperEightPresenterReload(_ upperEightPresenter: UpperEightPresenter)
}

class UpperEightPresenter: NSObject {
    weak var delegate: UpperEightPresenterDelegate?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: ProductInteractor.pageLoadedNotification,
                                               object: nil,
                                               queue: OperationQueue.current,
                                               using: { n in self.onReload(n as NSNotification) })
        
        
        NotificationCenter.default.addObserver(forName: ProductInteractor.dataUpdatedFromDatabase,
                                               object: nil,
                                               queue: OperationQueue.current,
                                               using: { n in self.onUpdate(n as NSNotification) })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    var count: Int { return min(ProductInteractor.shared.count, 8) }
    
    func imageURL(for index: Int) -> String? {
        return (ProductInteractor.shared[index]?.image as? ImageEntity)?.url
    }
    
    /// Calculates rects according to bounds, so that we ensure 4 and part of the fifth is displayed
    ///
    /// - Parameter bounds: The bounds to put the rects in
    /// - Returns: The sizes
    func calculateRects(in bounds: CGRect) -> [CGSize] {
        var sizes: [CGSize] = []
        var maximumHeight: CGFloat = 0.0
        for i in 0...4 {
            if let img = ProductInteractor.shared[i]?.image as? ImageEntity {
                sizes.append(CGSize(width: img.width, height: img.height))
                maximumHeight = max(CGFloat(img.height), maximumHeight)
            } else {
                fatalError("Something nil here!")
            }
        }
        var sumWidths = CGFloat(0)
        for i in 0...4 {
            sizes[i].width = (maximumHeight / sizes[i].height) * sizes[i].width
            sizes[i].height = maximumHeight
            sumWidths += (i == 4) ? (sizes[i].width / 10) : sizes[i].width
        }
        sumWidths += 15 // For interstitial spaces
        let ratio = bounds.width / sumWidths
        for i in 0...4 {
            sizes[i].width = ratio * sizes[i].width
            sizes[i].height = ratio * sizes[i].height
        }
        let height = sizes[0].height // All heights now are supposed to be equal, so take anyone
        for i in 5..<count {
            if let img = ProductInteractor.shared[i]?.image as? ImageEntity {
                sizes.append(CGSize(width: img.width, height: img.height))
                sizes[i].width = (height / sizes[i].height) * sizes[i].width
                sizes[i].height = height
            } else {
                fatalError("Something nil here")
            }
        }
        return sizes
    }
    
    func reload() {
        ProductInteractor.shared.readNewPage()
    }
    
    func onReload(_ notification: NSNotification) {
        if let page = notification.object as? Range<Int> {
            // First page is 0 - 7
            if page.overlaps(Range<Int>.init(uncheckedBounds: (0, 7))) {
                delegate?.upperEightPresenterReload(self)
            }
        }
    }
    
    func onUpdate(_ notification: NSNotification) {
        if let changes = notification.object as? [Int] {
            // First page is 0 - 7
            if changes.contains(where: {$0 >= 0 && $0 <= 7}) {
                delegate?.upperEightPresenterReload(self)
            }
        }
    }
}
